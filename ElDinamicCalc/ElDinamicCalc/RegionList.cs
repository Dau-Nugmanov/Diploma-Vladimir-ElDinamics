using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;

namespace ElDinamicCalc
{
	public static class RegionList
	{
		public static int SizeOfX, SizeOfY;
		public static decimal DelX, DelY, DelT;
		public static decimal Eps;
		public static int BoundsWidth;
		public static decimal Sigma;
		public static decimal CoefG;
		public static string Describ;

		public static List<Region> Regions = new List<Region>();
		public static List<Field> Fields2 = new List<Field>();

		public static int FileCode = 13031979;

		static RegionList()
		{
			FieldList = new List<Field>();
			SizeOfX = 201;
			SizeOfY = 101;
			DelX = 1e-6m;
			DelY = 1e-6m;
			DelT = DelX / PhisicalConstants.C * 0.2m;
			Eps = 1;
			SetEpsField();
		}

		public static ExtArr EpsField { get; set; }
		public static ExtArr Eps2Field { get; set; }
		public static BoundsType BoundsType { get; set; }
		public static List<Field> FieldList { get; set; }

		public static byte[] Contour { get; private set; }

		private static byte[] GetRgbValues(Bitmap bmp)
		{
			// Lock the bitmap's bits. 
			var rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
			var bmpData = bmp.LockBits(rect, ImageLockMode.ReadOnly, bmp.PixelFormat);

			// Get the address of the first line.
			var ptr = bmpData.Scan0;

			// Declare an array to hold the bytes of the bitmap.
			var bytes = bmpData.Stride * bmp.Height;
			var rgbValues = new byte[bytes];

			// Copy the RGB values into the array.
			Marshal.Copy(ptr, rgbValues, 0, bytes);
			bmp.UnlockBits(bmpData);

			return rgbValues;
		}

		public static bool LoadFromFile(string fileName)
		{
			using (var reader = new BinaryReader(File.OpenRead(fileName)))
			{
				Regions.Clear();
				Fields2.Clear();
				var code = reader.ReadInt32();
				if (code != FileCode)
				{
					throw new Exception(fileName + " is not correct medium file");
				}

				SizeOfX = reader.ReadUInt16();
				SizeOfY = reader.ReadUInt16();
				DelX = reader.ReadExtended();
				DelY = reader.ReadExtended();
				DelT = reader.ReadExtended();
				Eps = reader.ReadExtended();
				BoundsType = (BoundsType)reader.ReadByte();
				BoundsWidth = reader.ReadInt32();
				Sigma = reader.ReadExtended();
				CoefG = reader.ReadExtended();

				int newCount = reader.ReadByte();
				var bitmap = new Bitmap(SizeOfX, SizeOfY);
				var gr = Graphics.FromImage(bitmap);
				gr.FillRectangle(new SolidBrush(Color.White), 0, 0, SizeOfX, SizeOfY);
				if (newCount != 0)
				{
					for (var i = 0; i < newCount; i++)
					{
						var region = new Region();
						if (!region.LoadFromStream(reader))
							return false;

						Regions.Add(region);
						region.DrawContour(gr, SizeOfX, SizeOfY);
					}
				}
				gr.Flush();
				gr.Save();

				Contour = GetRgbValues(bitmap);

				SetEpsField();

				newCount = reader.ReadInt32();
				if (newCount != 0)
				{
					for (var i = 0; i < newCount; i++)
					{
						var t = reader.ReadByte();
						var fieldType = (InitialFieldType)t;

						Field field;
						switch (fieldType)
						{
							case InitialFieldType.Sin:
								field = new SinField();
								break;
							case InitialFieldType.Gauss:
								field = new GaussField();
								break;
							case InitialFieldType.RectSelf:
								field = new RectSelfField();
								break;
							case InitialFieldType.RectSelf2:
								field = new RectSelfField2();
								break;
							default:
								throw new Exception();
						}
						field.LoadFromStream(reader);
						Fields2.Add(field);
					}
				}
				var len = reader.ReadInt32();
				if (len == 0) return true;
				var tempDescrib = reader.ReadChars(len);
				Describ = Convert.ToString(tempDescrib);
			}
			SetInitialWave();
			return true;
		}

		private static void SetInitialWave()
		{
			if (FieldList.Count == 0)
			{
				switch (CommonParams.ModeType)
				{
					case ModeType.TE:
						switch (CommonParams.InitialWave)
						{
							case InitialWave.Sin:
								WaveInitializer.PlaneWaveTE();
								break;
							case InitialWave.Gauss:
								WaveInitializer.GaussTE();
								break;
						}
						break;

					case ModeType.TM:
						switch (CommonParams.InitialWave)
						{
							case InitialWave.Sin:
								WaveInitializer.PlaneWaveTM();
								break;
							case InitialWave.Gauss:
								WaveInitializer.GaussTM();
								break;
						}
						break;
				}
			}
			else
			{
				WaveInitializer.WaveFromRegionList();
			}
		}
		
		private static void SetEpsField()
		{
			EpsField = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, 0, 0);
			Eps2Field = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, 0, 0);

			for (var i = 0; i < SizeOfX; i++)
				for (var j = 0; j < SizeOfY; j++)
				{
					EpsField[i, j] = Eps;
					for (var k = 0; k < Regions.Count; k++)
					{
						if (Regions[k].Figure.Belong(i, j))
						{
							EpsField[i, j] = Regions[k].Eps;
							Eps2Field[i, j] = Regions[k].Eps2;
							break;
						}
					}
					if (BoundsType != BoundsType.Metall) continue;
					if (i == 0 || i == SizeOfX || j == 0 || j == SizeOfY)
						EpsField[i, j] = 0;
				}
		}
	}
}