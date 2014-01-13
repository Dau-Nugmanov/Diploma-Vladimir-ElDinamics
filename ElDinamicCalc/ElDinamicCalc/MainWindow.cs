using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Linq;
using System.Windows.Forms;

namespace ElDinamicCalc
{
	public partial class MainWindow : Form
	{
		private readonly TThr tr = new TThr();
		private Color[] ColorArray;
		private Bitmap WaveBitmap;
		private Graphics graph;
		private readonly decimal Max = Common6.BlackValue * GetMaxValue(TFieldType.ftEType);
		private readonly decimal Min = Common6.WhiteValue * GetMaxValue(TFieldType.ftEType);

			

		public MainWindow()
		{
			InitializeComponent();
		}

		private void button1_Click(object sender, EventArgs e)
		{
			try
			{
				DoWork(null);
				//ThreadPool.QueueUserWorkItem(DoWork);
			}
			catch (Exception ex)
			{
				//throw;
			}
		}

		private void DoWork(object state)
		{
			RegionList.LoadFromFile(
				@"F:\Users\Nugmanov\Dropbox\Дипломки\Diploma-Vladimir-ElDinamics\ElDinamicCalc\ElDinamicCalc\Manenkov.mdm");


			SetInitialWave();
			Common6.SizeX = RegionList.SizeOfX;
			Common6.SizeY = RegionList.SizeOfY;
			Common6.DelX = RegionList.DelX;
			Common6.DelY = RegionList.DelY;
			Common6.DelT = RegionList.DelT;
			Common6.DtDivDx = Common6.DelT/Common6.DelX;
			Common6.DtDivDy = Common6.DelT/Common6.DelY;

			Common6.BoundWidth = RegionList.BoundsWidth;
			Common6.SigmaX = RegionList.Sigma;
			Common6.SigmaY = RegionList.Sigma;

			Common6.CoefG = RegionList.CoefG;

			if (Common6.InitialX2 >= Common6.SizeX)
				Common6.InitialX2 = Common6.SizeX - 1;
			if (Common6.InitialY2 >= Common6.SizeY)
				Common6.InitialY2 = Common6.SizeY - 1;

			drawPanel.Size = new Size(Common6.SizeX, Common6.SizeY);
			graph = drawPanel.CreateGraphics();
			WaveBitmap = new Bitmap(Common6.SizeX, Common6.SizeY, graph);

			var br = new LinearGradientBrush(new Point(0, 0),
				new Point(0, 256), Color.White, Color.Black);
			var p = new Pen(br);


			using (var bitmap = new Bitmap(256, 1)) // 100x100 pixels
			using (Graphics graphics = Graphics.FromImage(bitmap))
			using (var brush = new LinearGradientBrush(
				new Rectangle(0, 0, 256, 1),
				Color.White,
				Color.Black,
				LinearGradientMode.ForwardDiagonal))
			{
				brush.SetSigmaBellShape(0.5f);
				graphics.FillRectangle(brush, new Rectangle(0, 0, 256, 1));
				ColorArray = new Color[256];

				for (int i = 0; i < 256; i++)
					ColorArray[i] = bitmap.GetPixel(i, 0);
			}

			tr.Execute(rbMultiThread.Checked);
		}

		

		private Color ColorByValue(decimal value)
		{
			var abs = Math.Abs(value);
			if (abs >= Max)
			{
				return Color.Black;
			}
			if (abs <= Min)
			{
				return Color.White;
			}
			return ColorArray[(int)Math.Round(255 * (abs - Min) / (Max - Min))];
		}

		private static decimal GetMaxValue(TFieldType fieldType)
		{
			switch (fieldType)
			{
				case TFieldType.ftEType:
					return PhisCnst.Ez0;
				case TFieldType.ftDType:
					return PhisCnst.Ez0*PhisCnst.Eps0*RegionList.Eps;
				case TFieldType.ftHType:
					return PhisCnst.Hz0;
				case TFieldType.ftBType:
					return PhisCnst.Hz0*PhisCnst.Mu0;
			}
			return 0.1m;
		}

		private void SetInitialWave()
		{
			if (Common6.InitialStyleSet.Any(s => s == TInitialStyle.isManual))
			{
				switch (Common6.ModeType)
				{
					case TModeType.mtTE:
						switch (Common6.InitialWave)
						{
							case TInitialWave.iwSin:
								Initial.PlaneWaveTE();
								break;
							case TInitialWave.iwGauss:
								Initial.GaussTE();
								break;
						}
						break;

					case TModeType.mtTM:
						switch (Common6.InitialWave)
						{
							case TInitialWave.iwSin:
								Initial.PlaneWaveTM();
								break;
							case TInitialWave.iwGauss:
								Initial.GaussTM();
								break;
						}
						break;
				}
			}
			if (Common6.InitialStyleSet.Any(s => s == TInitialStyle.isFromMedium))
			{
				Initial.WaveFromRegionList();
			}
		}

		private void Draw()
		{
			if (WaveBitmap == null) return;

			var width = WaveBitmap.Width;
			var height = WaveBitmap.Height;
			if (Common6.DrawQueue.Count == 0) return;
			var temp = Common6.DrawQueue.Dequeue();
			if (temp == null) return;

			var sourceData = WaveBitmap.LockBits(new Rectangle(new Point(0, 0), WaveBitmap.Size),
							 ImageLockMode.ReadWrite,
							 WaveBitmap.PixelFormat);

			var sourceStride = sourceData.Stride;
			var sourceScan0 = sourceData.Scan0;
			var sourcePixelSize = sourceStride / width;
			var bytes = Math.Abs(sourceStride) * height;
			var rgbValues = new byte[bytes];

			// Copy the RGB values into the array.
			System.Runtime.InteropServices.Marshal.Copy(sourceScan0, rgbValues, 0, bytes);

			for (var y = 0; y < height; y++)
			{
				for (var x = 0; x < width; x++)
				{
					var c = ColorByValue(temp[x, y]);
					rgbValues[y * sourceStride + x * sourcePixelSize] = c.B;
					rgbValues[y * sourceStride + x * sourcePixelSize + 1] = c.G;
					rgbValues[y * sourceStride + x * sourcePixelSize + 2] = c.R;
					rgbValues[y * sourceStride + x * sourcePixelSize + 3] = 255;
				}
			}

			// Copy the RGB values back to the bitmap
			System.Runtime.InteropServices.Marshal.Copy(rgbValues, 0, sourceScan0, bytes);

			// Unlock the bits.
			WaveBitmap.UnlockBits(sourceData);

			graph.DrawImage(WaveBitmap, new Point(0, 0));

			tbStep.Text = Common6.Tn.ToString();
			tbQueueCount.Text = Common6.DrawQueue.Count.ToString();
		}

		private void timerDraw_Tick(object sender, EventArgs e)
		{
			Draw();
		}
	}
}