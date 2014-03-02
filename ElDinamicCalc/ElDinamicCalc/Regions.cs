using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;

namespace ElDinamicCalc
{
	public abstract class Figure
	{
		public int X { get; set; }
		public int Y { get; set; }
		public TContourShape Shape { get; set; }
		public abstract int Param1 { get; set; }
		public abstract int Param2 { get; set; }
		public abstract bool Belong(int x, int y);
		public abstract bool BelongContour(int x, int y);
		public abstract void Align(THorAlign horAlign, TVertAlign vertAlign,
			int sizeX, int sizeY);
		public abstract void DrawContour(Graphics graph, int height, int width);
	}

	public class Rect : Figure
	{
		public int Width { get; set; }
		public int Height { get; set; }

		public override int Param1
		{
			get { return Width; }
			set
			{
				Width = value;
			}
		}
		public override int Param2
		{
			get { return Height; }
			set
			{
				Height = value;
			}
		}

		public override bool Belong(int x, int y)
		{
			return (x >= X) && (x < X + Width) &&
				   (y >= Y) && (y < Y + Height);
		}

		public override bool BelongContour(int x, int y)
		{
			return (x == X) || (x == X + Width) ||
				   (y == Y) || (y == Y + Height);
		}

		public override void Align(THorAlign horAlign, TVertAlign vertAlign, int sizeX, int sizeY)
		{
			switch (horAlign)
			{
				case THorAlign.haLeft:
					X = 0;
					break;
				case THorAlign.haRight:
					X = sizeX - Width;
					break;
				case THorAlign.haCenter:
					X = sizeX % 2 - Width % 2;
					break;
			}
			switch (vertAlign)
			{
				case TVertAlign.vaBottom:
					Y = sizeY - Height;
					break;
				case TVertAlign.vaTop:
					Y = 0;
					break;
				case TVertAlign.vaCenter:
					Y = sizeY % 2 - Height % 2;
					break;
			}
		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			graph.DrawRectangle(new Pen(Color.Black, 1), X, Y, Width, Height);
			graph.Flush();
			graph.Save();
		}
	}

	public class Circle : Figure
	{
		public override int Param1
		{
			get { return Radius; }
			set { Radius = value; }
		}

		public override int Param2
		{
			get { return Radius; }
			set { Radius = value; }
		}
		public int Radius { get; set; }
		public override bool Belong(int x, int y)
		{
			return Math.Pow(x - X, 2) + Math.Pow(y - Y, 2)
					<= Math.Pow(Radius, 2);
		}

		public override bool BelongContour(int x, int y)
		{
			return Math.Abs(Math.Pow(x - X, 2)
					+ Math.Pow(y - Y, 2)
					- Math.Pow(Radius, 2)) < 0.5;
		}

		public override void Align(THorAlign horAlign, TVertAlign vertAlign, int sizeX, int sizeY)
		{

			switch (horAlign)
			{
				case THorAlign.haLeft:
					X = Radius;
					break;
				case THorAlign.haRight:
					X = sizeX - Radius;
					break;
				case THorAlign.haCenter:
					X = sizeX % 2;
					break;
			}

			switch (vertAlign)
			{
				case TVertAlign.vaBottom:
					Y = sizeY - Radius;
					break;
				case TVertAlign.vaTop:
					Y = Radius;
					break;
				case TVertAlign.vaCenter:
					Y = sizeY % 2;
					break;
			}
		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			graph.DrawEllipse(new Pen(Color.Black, 1),
				X - Radius, Y - Radius, Radius * 2, Radius * 2);
			graph.Flush();
			graph.Save();
		}
	}

	public class Ellipse : Figure
	{
		public override int Param1
		{
			get { return HorAxel; }
			set { HorAxel = value; }
		}

		public override int Param2
		{
			get { return VertAxel; }
			set { VertAxel = value; }
		}
		public int HorAxel { get; set; }
		public int VertAxel { get; set; }

		public override bool Belong(int x, int y)
		{
			return Math.Pow(x - X, 2) / Math.Pow(HorAxel, 2)
				+ Math.Pow(y - Y, 2) / Math.Pow(VertAxel, 2)
				<= 1;
		}

		public override bool BelongContour(int x, int y)
		{
			return Math.Abs(Math.Pow(x - X, 2) / Math.Pow(HorAxel, 2)
					+ Math.Pow(y - Y, 2) / Math.Pow(VertAxel, 2)
					- 1) < 0.5;
		}

		public override void Align(THorAlign horAlign, TVertAlign vertAlign, int sizeX, int sizeY)
		{

			switch (horAlign)
			{
				case THorAlign.haLeft:
					X = HorAxel;
					break;
				case THorAlign.haRight:
					X = sizeX - HorAxel;
					break;
				case THorAlign.haCenter:
					X = sizeX % 2;
					break;
			}

			switch (vertAlign)
			{
				case TVertAlign.vaBottom:
					Y = sizeY - VertAxel;
					break;
				case TVertAlign.vaTop:
					Y = VertAxel;
					break;
				case TVertAlign.vaCenter:
					Y = sizeY % 2;
					break;
			}
		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			graph.DrawEllipse(new Pen(Color.Black, 1),
				X - HorAxel, Y - VertAxel, HorAxel * 2, VertAxel * 2);
			graph.Flush();
			graph.Save();
		}
	}

	public class HalfSpace : Figure
	{
		public override int Param1 { get; set; }
		public override int Param2 { get; set; }
		public TOrientation Orientation { get; set; }

		public override bool Belong(int x, int y)
		{
			switch (Orientation)
			{
				case TOrientation.orLeft:
					return x <= X;
				case TOrientation.orRight:
					return x >= X;
				case TOrientation.orTop:
					return y <= Y;
				case TOrientation.orBottom:
					return y >= Y;
			}
			return false;
		}

		public override bool BelongContour(int x, int y)
		{
			switch (Orientation)
			{
				case TOrientation.orLeft:
					return x == X;
				case TOrientation.orRight:
					return x == X;
				case TOrientation.orTop:
					return y == Y;
				case TOrientation.orBottom:
					return y == Y;
			}
			return false;
		}

		public override void Align(THorAlign horAlign, TVertAlign vertAlign, int sizeX, int sizeY)
		{

		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			switch (Orientation)
			{
				case TOrientation.orLeft:
					graph.DrawRectangle(new Pen(Color.Black, 1),
				0, 0, X, height);
					break;
				case TOrientation.orRight:
					graph.DrawRectangle(new Pen(Color.Black, 1),
				X, 0, width, height);
					break;
				case TOrientation.orTop:
					graph.DrawRectangle(new Pen(Color.Black, 1),
				0, 0, width, Y);
					break;
				case TOrientation.orBottom:
					graph.DrawRectangle(new Pen(Color.Black, 1),
				0, X, width, height);
					break;
			}

			graph.Flush();
			graph.Save();
		}
	}

	public abstract class Field
	{
		public TInitialFieldType FieldType { get; set; }

		public int SizeOfX { get; set; }
		public int SizeOfY { get; set; }
		public int StartX { get; set; }
		public int StartY { get; set; }
		public int HalfX { get; set; }
		public int HalfY { get; set; }
		public decimal BettaX { get; set; }
		public decimal BettaY { get; set; }

		protected void Setup()
		{
		}

		public void SetField(int sizeX, int sizeY, int startX, int startY,
			int halfX, int halfY)
		{
			SizeOfX = sizeX;
			SizeOfY = sizeY;
			StartX = startX;
			StartY = startY;
			HalfX = halfX;
			HalfY = halfY;
			BettaX = ExtMath.Pi / SizeOfX * HalfX / RegionList.DelX;
			BettaY = ExtMath.Pi / SizeOfY * HalfY / RegionList.DelY;
		}

		public abstract void FillEx(ExtArr eX);
		public abstract void FillEy(ExtArr eY);
		public abstract void FillEz(ExtArr eZ);
		public abstract void FillDx(ExtArr dX);
		public abstract void FillDy(ExtArr dY);
		public abstract void FillDz(ExtArr dZ);
		public abstract void FillBx(ExtArr bX);
		public abstract void FillBy(ExtArr bY);
		public abstract void FillBz(ExtArr bZ);
		public abstract void FillHx(ExtArr hX);
		public abstract void FillHy(ExtArr hY);
		public abstract void FillHz(ExtArr hZ);
		public abstract void FillEzMax(ExtArr eZ);
		public abstract void FillHyMax(ExtArr hY);

		public void SaveToStream(MemoryStream stream)
		{
			//Stream.WriteBuffer(FFieldType, SizeOf(FieldType));
			//Stream.WriteBuffer(FSizeOfX, SizeOf(Integer));
			//Stream.WriteBuffer(FSizeOfY, SizeOf(Integer));
			//Stream.WriteBuffer(FStartX, SizeOf(Integer));
			//Stream.WriteBuffer(FStartY, SizeOf(Integer));
			//Stream.WriteBuffer(FHalfX, SizeOf(Integer));
			//Stream.WriteBuffer(FHalfY, SizeOf(Integer));
			//Stream.WriteBuffer(FBettaX, SizeOf(Extended));
			//Stream.WriteBuffer(FBettaY, SizeOf(Extended));
		}

		public virtual bool LoadFromStream(BinaryReader reader)
		{
			try
			{
				SizeOfX = reader.ReadInt32();
				SizeOfY = reader.ReadInt32();
				StartX = reader.ReadInt32();
				StartY = reader.ReadInt32();
				HalfX = reader.ReadInt32();
				HalfY = reader.ReadInt32();
				BettaX = reader.ReadExtended();
				BettaY = reader.ReadExtended();
			}
			catch (Exception)
			{
				return false;
			}
			return true;
		}

		public void Assign(Field source)
		{
			SizeOfX = source.SizeOfX;
			SizeOfY = source.SizeOfY;
			StartX = source.StartX;
			StartY = source.StartY;
			HalfX = source.HalfX;
			HalfY = source.HalfY;
			BettaX = source.BettaX;
			BettaY = source.BettaY;
		}

		public void Realloc(ref ExtArr fieldComp)
		{
			if ((fieldComp.SizeX < SizeOfX) || (fieldComp.SizeY < SizeOfY)
				|| (fieldComp.StartX > StartX) || (fieldComp.StartY > StartY))
			{
				fieldComp = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, StartX, StartY);
			}
		}
	}

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
			DelT = DelX / PhisCnst.C * 0.2m;
			Eps = 1;
			SetEpsField();
		}

		public static ExtArr EpsField { get; set; }
		public static ExtArr Eps2Field { get; set; }
		public static TBoundsType BoundsType { get; set; }
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
					BoundsType = (TBoundsType)reader.ReadByte();
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
							var fieldType = (TInitialFieldType)t;

							Field field;
							switch (fieldType)
							{
								case TInitialFieldType.ftSin:
									field = new SinField();
									break;
								case TInitialFieldType.ftGauss:
									field = new GaussField();
									break;
								case TInitialFieldType.ftRectSelf:
									field = new RectSelfField();
									break;
								case TInitialFieldType.ftRectSelf2:
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
			
			return true;
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
					if (BoundsType != TBoundsType.btMetall) continue;
					if (i == 0 || i == SizeOfX || j == 0 || j == SizeOfY)
						EpsField[i, j] = 0;
				}
		}
	}

	public class RectSelfField2 : Field
	{
		public override void FillEx(ExtArr eX)
		{
			throw new NotImplementedException();
		}

		public override void FillEy(ExtArr eY)
		{
			throw new NotImplementedException();
		}

		public override void FillEz(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillDx(ExtArr dX)
		{
			throw new NotImplementedException();
		}

		public override void FillDy(ExtArr dY)
		{
			throw new NotImplementedException();
		}

		public override void FillDz(ExtArr dZ)
		{
			throw new NotImplementedException();
		}

		public override void FillBx(ExtArr bX)
		{
			throw new NotImplementedException();
		}

		public override void FillBy(ExtArr bY)
		{
			throw new NotImplementedException();
		}

		public override void FillBz(ExtArr bZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHx(ExtArr hX)
		{
			throw new NotImplementedException();
		}

		public override void FillHy(ExtArr hY)
		{
			throw new NotImplementedException();
		}

		public override void FillHz(ExtArr hZ)
		{
			throw new NotImplementedException();
		}

		public override void FillEzMax(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHyMax(ExtArr hY)
		{
			throw new NotImplementedException();
		}
	}

	public class RectSelfField : Field
	{
		public Region Rect { get; set; }

		public int RectNum { get; set; }

		public int ModeNum { get; set; }

		public decimal B { get; set; }

		public decimal A { get; set; }

		public decimal R { get; set; }

		public decimal P { get; set; }

		public decimal Q { get; set; }

		public decimal Betta { get; set; }

		public decimal K { get; set; }

		public decimal Size { get; set; }

		public int HalfY { get; set; }

		public decimal Eps { get; set; }

		public decimal EpsA { get; set; }

		public decimal EpsB { get; set; }

		public decimal DelY { get; set; }

		public bool Odd { get; set; }

		public bool Sym { get; set; }

		public int One { get; set; }

		public decimal ZeroPoint { get; set; }

		public decimal BettaY { get; set; }

		public override bool LoadFromStream(BinaryReader reader)
		{
			bool res;
			try
			{
				res = base.LoadFromStream(reader);
				if (res)
				{
					Q = reader.ReadExtended();
					P = reader.ReadExtended();
					R = reader.ReadExtended();
					A = reader.ReadExtended();
					B = reader.ReadExtended();
					ModeNum = reader.ReadInt32();
					RectNum = reader.ReadInt32();

					Rect = RegionList.Regions[RectNum];
					DelY = RegionList.DelY;
					Eps = Rect.Eps;
					EpsA = RegionList.EpsField[Rect.Figure.X + Rect.Figure.Param1 % 2,
						Rect.Figure.Y + Rect.Figure.Param2 + 2];

					Sym = (EpsA == EpsB);
					Size = Rect.Figure.Param2 * DelY / 2;
					Betta = ExtMath.Sqrt(Eps * ExtMath.Pow(K, 2) - ExtMath.Pow(Q, 2));
					ZeroPoint = Rect.Figure.Y + Rect.Figure.Param2 / 2;
					Odd = (ModeNum + 2) % 2 == 1;
					One = Convert.ToInt32(Odd) * 2 - 1; //+-1
				}
			}
			catch (Exception)
			{
				res = false;
			}
			return res;
		}


		public decimal Bell(int i)
		{
			return ExtMath.Sqrt(ExtMath.Sin(ExtMath.Pi * (i - StartX) / SizeOfX));
		}

		public void CalculateParams()
		{
			decimal leftRoot, rightRoot, root;
			Func<decimal, decimal> funct;
			
			Odd = (ModeNum + 2) % 2 == 1;
			One = Convert.ToInt32(Odd) * 2 - 1; //+-1

			EpsA = RegionList.EpsField[Rect.Figure.X + Rect.Figure.Param1 % 2,
				Rect.Figure.Y - 1];
			EpsB = RegionList.EpsField[Rect.Figure.X + Rect.Figure.Param1 % 2,
				Rect.Figure.Y + Rect.Figure.Param2 + 2];

			Sym = EpsA == EpsB;

			//CoefA = Size;
			// CoefP1 = ExtMath.Sqrt(K) * (Eps - EpsA);
			// CoefP2 = 1;
			// CoefR1 = ExtMath.Sqrt(K) * (Eps - EpsB);
			// CoefR2 = 1;
			// Coef1 = ExtMath.Sqrt(K) * (Eps - EpsA);
			// Coef2 = 1;


			if (Sym)
			{
				if (Odd)
				{
					funct = Regions.FTan;
				}
				else
				{
					funct = Regions.FCotan;
				}

				leftRoot = (ModeNum - 1.5m) * ExtMath.Pi / Size + 0.1m;
				if (leftRoot < 0)
				{
					leftRoot = 0.1m;
				}

				rightRoot = (ModeNum - 0.5m) * ExtMath.Pi / Size - 0.1m;
				root = (leftRoot + rightRoot) / 2;
			}
			else
			{
				funct = Regions.FSelfMode;
				FindLeftRight(out leftRoot, out rightRoot, out root);
			}

			if (!ExtMath.FindRoot(funct, leftRoot, rightRoot, Q, 0.1m, 30000)
				|| Math.Abs(Q) < 10)
			{
				if (!ExtMath.Newton(funct, root, Q, 0.0001m, 30000) || Math.Abs(Q) < 10)
				{
					throw new Exception("Невозможно задать моду с такими параметрами");
				}
			}

			if (Sym)
			{
				if (Odd)
				{
					P = -Q * ExtMath.Tan(Q * Size);
					A = PhisCnst.Ez0;
					B = 0;
				}
				else
				{
					P = -Q * (1 / ExtMath.Tan(Q * Size));
					A = 0;
					B = PhisCnst.Ez0;
				}
				R = P;
			}
			else
			{
				P = Regions.SelfModeP(Q);
				R = Regions.SelfModeR(Q);

				if (Q + P * ExtMath.Tan(Q * Size) != 0)
				{
					A = PhisCnst.Ez0 / ((P - Q * ExtMath.Tan(Q * Size))
									  / (Q + P * ExtMath.Tan(Q * Size)) + 1);
				}
				else
				{
					A = 0;
				}
				B = PhisCnst.Eps0 - A;
			}
			Betta = ExtMath.Sqrt(Eps * ExtMath.Pow(K, 2) - ExtMath.Pow(Q, 2));
			SizeOfX = (int)Math.Round(HalfX / Betta * ExtMath.Pi / RegionList.DelX);
		}

		public void FindLeftRight(out decimal leftRoot, out decimal rightRoot,
			out decimal root)
		{
			leftRoot = (ModeNum - 1.5m) * ExtMath.Pi / 2 / Size + 0.1m;
			if (leftRoot < 0)
			{
				leftRoot = 0.1m;
			}
			rightRoot = (ModeNum - 0.5m) * ExtMath.Pi / 2 / Size - 0.1m;

			decimal assim = K * ExtMath.Sqrt((Eps - EpsA) * (Eps - EpsB) / (2 * Eps - EpsA - EpsB));

			if (assim > leftRoot && assim < rightRoot)
			{
				if (ExtMath.Tan(2 * Size * assim) < 0)
				{
					rightRoot = assim - 0.1m;
				}
				else
				{
					leftRoot = assim + 0.1m;
				}
			}
			if (rightRoot > ExtMath.Sqrt(Eps - EpsA) * K)
			{
				rightRoot = ExtMath.Sqrt(Eps - EpsA) * K - 0.1m;
			}
			if (rightRoot > ExtMath.Sqrt(Eps - EpsB) * K)
			{
				rightRoot = ExtMath.Sqrt(Eps - EpsB) * K - 0.1m;
			}

			root = (leftRoot + rightRoot) / 2;
		}

		public override void FillEx(ExtArr eX)
		{
			throw new NotImplementedException();
		}

		public override void FillEy(ExtArr eY)
		{
			throw new NotImplementedException();
		}

		public override void FillEz(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillDx(ExtArr dX)
		{
			throw new NotImplementedException();
		}

		public override void FillDy(ExtArr dY)
		{
			throw new NotImplementedException();
		}

		public override void FillDz(ExtArr dZ)
		{
			throw new NotImplementedException();
		}

		public override void FillBx(ExtArr bX)
		{
			throw new NotImplementedException();
		}

		public override void FillBy(ExtArr bY)
		{
			throw new NotImplementedException();
		}

		public override void FillBz(ExtArr bZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHx(ExtArr hX)
		{
			throw new NotImplementedException();
		}

		public override void FillHy(ExtArr hY)
		{
			throw new NotImplementedException();
		}

		public override void FillHz(ExtArr hZ)
		{
			throw new NotImplementedException();
		}

		public override void FillEzMax(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHyMax(ExtArr hY)
		{
			throw new NotImplementedException();
		}
	}

	public class GaussField : Field
	{
		public decimal ExpY { get; set; }

		public decimal ExpX { get; set; }

		public override bool LoadFromStream(BinaryReader reader)
		{
			bool res = base.LoadFromStream(reader);
			if (res)
			{
				ExpX = reader.ReadExtended();
				ExpY = reader.ReadExtended();
			}
			return res;
		}

		public override void FillEx(ExtArr eX)
		{
			throw new NotImplementedException();
		}

		public override void FillEy(ExtArr eY)
		{
			throw new NotImplementedException();
		}

		public override void FillEz(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillDx(ExtArr dX)
		{
			throw new NotImplementedException();
		}

		public override void FillDy(ExtArr dY)
		{
			throw new NotImplementedException();
		}

		public override void FillDz(ExtArr dZ)
		{
			throw new NotImplementedException();
		}

		public override void FillBx(ExtArr bX)
		{
			throw new NotImplementedException();
		}

		public override void FillBy(ExtArr bY)
		{
			throw new NotImplementedException();
		}

		public override void FillBz(ExtArr bZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHx(ExtArr hX)
		{
			throw new NotImplementedException();
		}

		public override void FillHy(ExtArr hY)
		{
			throw new NotImplementedException();
		}

		public override void FillHz(ExtArr hZ)
		{
			throw new NotImplementedException();
		}

		public override void FillEzMax(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHyMax(ExtArr hY)
		{
			throw new NotImplementedException();
		}
	}

	public class SinField : Field
	{
		public override void FillEx(ExtArr eX)
		{
			throw new NotImplementedException();
		}

		public override void FillEy(ExtArr eY)
		{
			throw new NotImplementedException();
		}

		public override void FillEz(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillDx(ExtArr dX)
		{
			throw new NotImplementedException();
		}

		public override void FillDy(ExtArr dY)
		{
			throw new NotImplementedException();
		}

		public override void FillDz(ExtArr dZ)
		{
			throw new NotImplementedException();
		}

		public override void FillBx(ExtArr bX)
		{
			throw new NotImplementedException();
		}

		public override void FillBy(ExtArr bY)
		{
			throw new NotImplementedException();
		}

		public override void FillBz(ExtArr bZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHx(ExtArr hX)
		{
			throw new NotImplementedException();
		}

		public override void FillHy(ExtArr hY)
		{
			throw new NotImplementedException();
		}

		public override void FillHz(ExtArr hZ)
		{
			throw new NotImplementedException();
		}

		public override void FillEzMax(ExtArr eZ)
		{
			throw new NotImplementedException();
		}

		public override void FillHyMax(ExtArr hY)
		{
			throw new NotImplementedException();
		}
	}

	public enum TBoundsType
	{
		btMetall,
		btAbsorb
	}

	public enum TContourShape
	{
		shRect,
		shCircle,
		shEllipse,
		shHalfSpace
	}

	public enum TOrientation
	{
		orLeft,
		orRight,
		orTop,
		orBottom
	}

	public enum TMatterType
	{
		mtVacuum,
		mtMetall,
		mtDielectr
	}

	public enum THorAlign
	{
		haLeft,
		haCenter,
		haRight,
		haNo
	}

	public enum TVertAlign
	{
		vaTop,
		vaCenter,
		vaBottom,
		vaNo
	}

	public enum TResizeDirection
	{
		rdLeft,
		rdRight,
		rdUp,
		rdDown
	}

	public enum TMouseAction
	{
		maMove,
		maResize
	}

	public enum TInitialFieldType
	{
		ftSin,
		ftGauss,
		ftRectSelf,
		ftRectSelf2
	}

	public class Regions
	{
		public static decimal CoefA,
			Coef1,
			Coef2,
			CoefR1,
			CoefR2,
			CoefP1,
			CoefP2;

		public static decimal FTan(decimal X)
		{
			return X * ExtMath.Tan(CoefA * X) - ExtMath.Sqrt(Coef1 - Coef2 * ExtMath.Pow(X, 2));
		}

		public static decimal FCotan(decimal X)
		{
			return -X * (1 / ExtMath.Tan(CoefA * X)) - ExtMath.Sqrt(Coef1 - Coef2 * ExtMath.Pow(X, 2));
		}

		public static decimal SelfModeR(decimal Q)
		{
			return ExtMath.Sqrt(CoefR1 - CoefR2 * ExtMath.Pow(Q, 2));
		}

		public static decimal SelfModeP(decimal Q)
		{
			return ExtMath.Sqrt(CoefP1 - CoefP2 * ExtMath.Pow(Q, 2));
		}

		public static decimal FSelfMode(decimal X)
		{
			return ExtMath.Tan(2 * X * CoefA) - X * (SelfModeP(X) + SelfModeR(X))
				   / (ExtMath.Pow(X, 2) - SelfModeP(X) * SelfModeR(X));
		}
	}
}