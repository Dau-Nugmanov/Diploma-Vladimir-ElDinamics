using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Schema;

namespace ElDinamicCalc
{
	public partial class MainWindow : Form
	{
		public MainWindow()
		{
			InitializeComponent();




		}

		private Graphics graph;
		private Bitmap WaveBitmap;
		private Color[] ColorArray;
		private TThr tr = new TThr();
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
			Common6.DtDivDx = Common6.DelT / Common6.DelX;
			Common6.DtDivDy = Common6.DelT / Common6.DelY;

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

			LinearGradientBrush br = new LinearGradientBrush(new Point(0, 0),
			new Point(0, 256), Color.White, Color.Black);
			Pen p = new Pen(br);


			using (Bitmap bitmap = new Bitmap(256, 1)) // 100x100 pixels
			using (Graphics graphics = Graphics.FromImage(bitmap))
			using (LinearGradientBrush brush = new LinearGradientBrush(
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

			tr.Execute();


			//if (Common6.Tn%2 == 0)
			//{
			//	drawPanel.Update();
			//	drawPanel.Invalidate();
			//}

		}

		//private void Draw()
		//{



		//	//var sourceData = WaveBitmap.LockBits(new Rectangle(new System.Drawing.Point(0, 0), WaveBitmap.Size),
		//	//				 ImageLockMode.ReadWrite,
		//	//				 WaveBitmap.PixelFormat);

		//	//var sourceStride = sourceData.Stride;

		//	//var sourceScan0 = sourceData.Scan0;

		//	//var sourcePixelSize = sourceStride / width;

		//	//int bytes = Math.Abs(sourceStride) * height;
		//	//byte[] rgbValues = new byte[bytes];

		//	//// Copy the RGB values into the array.
		//	//System.Runtime.InteropServices.Marshal.Copy(sourceScan0, rgbValues, 0, bytes);

		//	//for (var y = 0; y < height; y++)
		//	//{
		//	//	for (var x = 0; x < width; x++)
		//	//	{
		//	//		Color c = ColorByValue(TFieldType.ftHType, Common6.WaveF[x, y]);
		//	//		rgbValues[y * sourceStride + x * sourcePixelSize+ 1] = 115;//c.R;
		//	//		rgbValues[y * sourceStride + x * sourcePixelSize + 2] = 115;//c.G;
		//	//		rgbValues[y * sourceStride + x * sourcePixelSize + 3] = 115;//c.B;
		//	//	}
		//	//}

		//	//// Copy the RGB values back to the bitmap
		//	//System.Runtime.InteropServices.Marshal.Copy(rgbValues, 0, sourceScan0, bytes);

		//	//// Unlock the bits.
		//	//WaveBitmap.UnlockBits(sourceData);

		//	//graph.DrawImage(WaveBitmap, new Point(0, 0));
		//}

		private Color ColorByValue(TFieldType fieldType, double value)
		{
			var max = Common6.BlackValue * GetMaxValue(fieldType);
			var min = Common6.WhiteValue * GetMaxValue(fieldType);

			if (Math.Abs(value) >= max)
			{
				return Color.Black;
			}
			if (Math.Abs(value) <= min)
			{
				return Color.White;
			}
			var c = ColorArray[(int)Math.Round(255 * (Math.Abs(value) - min) / (max - min))];
			return c;
		}

		private double GetMaxValue(TFieldType fieldType)
		{
			switch (fieldType)
			{
				case TFieldType.ftEType:
					return PhisCnst.Ez0;
				case TFieldType.ftDType:
					return PhisCnst.Ez0 * PhisCnst.Eps0 * RegionList.Eps;
				case TFieldType.ftHType:
					return PhisCnst.Hz0;
				case TFieldType.ftBType:
					return PhisCnst.Hz0 * PhisCnst.Mu0;
			}
			return 0.1;
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

		private void drawPanel_Paint(object sender, PaintEventArgs e)
		{
			tbStep.Text = Common6.Tn.ToString();
		}

		private void timerDraw_Tick(object sender, EventArgs e)
		{
			if (WaveBitmap == null) return;

			var width = WaveBitmap.Width;
			var height = WaveBitmap.Height;
			if (Common6.DrawQueue.Count == 0) return;

			var temp = Common6.DrawQueue.Dequeue();
			if (temp == null) return;
			//graph.Clear(Color.White);
			for (var y = 0; y < height; y++)
			{
				for (var x = 0; x < width; x++)
				{
					if ((x + y + 2) % 2 == 0)
						WaveBitmap.SetPixel(x, y, ColorByValue(TFieldType.ftEType, (double)temp[x, y]));
				}
			}
			graph.DrawImage(WaveBitmap, new Point(0, 0));
			tbStep.Text = (Convert.ToInt32(tbStep.Text) + 1).ToString();
		}
	}
}
