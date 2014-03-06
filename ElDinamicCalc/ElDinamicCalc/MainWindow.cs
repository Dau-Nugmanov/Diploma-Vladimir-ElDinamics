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
		private bool _isWorking;

		private Stopwatch _stopwatch = new Stopwatch();

		public MainWindow()
		{
			InitializeComponent();
			_stopwatch.Reset();
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

			toolStripStatusLabelStepNum.Text = temp.Step.ToString();
			toolStripStatusLabelQueueCount.Text = CommonParams.DrawQueue.Count.ToString();
			toolStripStatusLabelTime.Text = _stopwatch.Elapsed.ToString("g");

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
			toolStripStatusLabelSize.Text = string.Format("{0}x{1}", CommonParams.SizeX, CommonParams.SizeY);
		}
		
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
				_stopwatch.Stop();
			}
			else
			{
				_stopwatch.Start();
				_mainThread.Start(CommonParams.WorkMode);
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
					PauseStepNum = CommonParams.PauseStepNum,
					DrawStepNum = CommonParams.DrawStepNum,
					CellSize = CommonParams.CellSize,
					WorkMode = CommonParams.WorkMode
				};
			var settingsForm = new SettingsForm(settings);
			if (settingsForm.ShowDialog() != DialogResult.OK) return;
			CommonParams.DelT = settingsForm.Settings.DelT;
			CommonParams.DelX = settingsForm.Settings.DelX;
			CommonParams.DelY = settingsForm.Settings.DelY;
			CommonParams.PauseStepNum = settings.PauseStepNum;
			CommonParams.DrawStepNum = settings.DrawStepNum;
			CommonParams.CellSize = settings.CellSize;
			CommonParams.WorkMode = settings.WorkMode;
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