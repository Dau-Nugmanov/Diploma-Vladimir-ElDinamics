using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace ElDinamicCalc
{
	/// <summary>
	/// Главная экранная форма программы
	/// </summary>
	public partial class MainWindow : Form
	{
		private MainThread _mainThread;
		private Bitmap _waveBitmap;
		private Graphics _graph;
		private string _filePath;


		public MainWindow()
		{
			InitializeComponent();
			toolStripComboBox.Items.Add(new ComboBoxItem { WorkMode = WorkMode.SingleThread });
			toolStripComboBox.Items.Add(new ComboBoxItem { WorkMode = WorkMode.MultiThread });
			toolStripComboBox.SelectedIndex = 0;
		}

		private void Draw()
		{
			if (_waveBitmap == null) return;

			if (CommonParams.DrawQueue.Count == 0) return;
			var temp = CommonParams.DrawQueue.Dequeue();
			if (temp == null) return;

			var sourceData = _waveBitmap.LockBits(new Rectangle(new Point(0, 0), _waveBitmap.Size),
							 ImageLockMode.ReadWrite,
							 _waveBitmap.PixelFormat);

			var sourceScan0 = sourceData.Scan0;

			// Copy the RGB values back to the bitmap
			Marshal.Copy(temp.Value, 0, sourceScan0, temp.Value.Length);

			// Unlock the bits.
			_waveBitmap.UnlockBits(sourceData);

			//_graph.DrawImage(ImageUtilities.ResizeImage(_waveBitmap, _waveBitmap.Width*4, _waveBitmap.Height*4), 0, 0);
			_graph.DrawImage(_waveBitmap, 0, 0, _waveBitmap.Width * 4, _waveBitmap.Height * 4);

			if (LastDrawTime.HasValue)
				WorkTime += DateTime.Now.Ticks - LastDrawTime.Value;

			toolStripStatusLabelStepNum.Text = temp.Step.ToString();
			toolStripStatusLabelQueueCount.Text = CommonParams.DrawQueue.Count.ToString();
			toolStripStatusLabelTime.Text = new TimeSpan(WorkTime).ToString("G");

			if (CommonParams.PauseStepNum != 0 && temp.Step % CommonParams.PauseStepNum == 0)
				buttonStart_Click(null, null);
		}
		private void timerDraw_Tick(object sender, EventArgs e)
		{
			Draw();
		}

		private void fileOpenToolStripMenuItem_Click(object sender, EventArgs e)
		{
			var result = openFileDialog.ShowDialog();
			if (result != DialogResult.OK) return;

			_filePath = openFileDialog.FileName;

			if (string.IsNullOrEmpty(_filePath) || !File.Exists(_filePath))
			{
				MessageBox.Show("Не задан файл");
				return;
			}

			if (_mainThread != null)
				_mainThread.Stop();

			drawPanel.Size = new Size(CommonParams.SizeX * 4, CommonParams.SizeY * 4);
			_graph = drawPanel.CreateGraphics();
			_graph.Clear(Color.White);
			_waveBitmap = new Bitmap(CommonParams.SizeX, CommonParams.SizeY, _graph);

			_mainThread = new MainThread(_filePath);
			LastDrawTime = null;
			WorkTime = 0;
		}

		private bool _isWorking;

		private long WorkTime { get; set; }
		private long? LastDrawTime { get; set; }
		private void buttonStart_Click(object sender, EventArgs e)
		{
			if (_mainThread == null)
			{
				MessageBox.Show("Не задан файл");
				return;
			}
			if (_isWorking)
			{
				_mainThread.Stop();
				buttonStart.Text = "Start";
			}
			else
			{
				if (!LastDrawTime.HasValue)
					LastDrawTime = DateTime.Now.Ticks;
				var comboBoxItem = toolStripComboBox.SelectedItem as ComboBoxItem;
				_mainThread.Start(comboBoxItem.WorkMode);
				buttonStart.Text = "Stop";
			}
			_isWorking = !_isWorking;
		}

		private void ExitToolStripMenuItem_Click(object sender, EventArgs e)
		{
			Close();
		}

		private void SettingsToolStripMenuItem_Click(object sender, EventArgs e)
		{
			var settings = new MainSettings
				{
					DelT = CommonParams.DelT,
					DelX = CommonParams.DelX,
					DelY = CommonParams.DelY,
					PauseStepNum = CommonParams.PauseStepNum
				};
			var settingsForm = new SettingsForm(settings);
			if (settingsForm.ShowDialog() != DialogResult.OK) return;
			CommonParams.DelT = settingsForm.Settings.DelT;
			CommonParams.DelX = settingsForm.Settings.DelX;
			CommonParams.DelY = settingsForm.Settings.DelY;
			CommonParams.PauseStepNum = settings.PauseStepNum;
			CommonParams.DtDivDx = CommonParams.DelT / CommonParams.DelX;
			CommonParams.DtDivDy = CommonParams.DelT / CommonParams.DelY;
		}

		private void MainWindow_ResizeEnd(object sender, EventArgs e)
		{
			if (_waveBitmap == null) return;
			_graph.DrawImage(_waveBitmap, 0, 0, _waveBitmap.Width * 4, _waveBitmap.Height * 4);
		}

		private void editorStartToolStripMenuItem_Click(object sender, EventArgs e)
		{
			var start = new ProcessStartInfo
			{
				FileName = "Editor.exe",
				WindowStyle = ProcessWindowStyle.Hidden,
				CreateNoWindow = true
			};
			using (var proc = Process.Start(start))
			{
				proc.WaitForExit();

				// Retrieve the app's exit code
				var exitCode = proc.ExitCode;
			}
		}
	}
}