using System;
using System.IO;

namespace ElDinamicCalc
{
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
					A = PhisicalConstants.Ez0;
					B = 0;
				}
				else
				{
					P = -Q * (1 / ExtMath.Tan(Q * Size));
					A = 0;
					B = PhisicalConstants.Ez0;
				}
				R = P;
			}
			else
			{
				P = Regions.SelfModeP(Q);
				R = Regions.SelfModeR(Q);

				if (Q + P * ExtMath.Tan(Q * Size) != 0)
				{
					A = PhisicalConstants.Ez0 / ((P - Q * ExtMath.Tan(Q * Size))
					                             / (Q + P * ExtMath.Tan(Q * Size)) + 1);
				}
				else
				{
					A = 0;
				}
				B = PhisicalConstants.Eps0 - A;
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
}