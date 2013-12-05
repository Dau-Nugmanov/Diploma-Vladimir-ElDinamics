using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
	public class Common6
	{
		public static readonly int SizeX0 = 201;
		public static readonly int SizeY0 = 101;
		public static readonly double DelX0 = 1e-6;
		public static readonly double DelY0 = DelX0;
		public static readonly double Lx0 = DelX0 * SizeX0;
		public static readonly double Ly0 = DelY0 * SizeY0;
		public static readonly double DelT0 = DelX0 / 9 / PhisCnst.C;
		public static readonly double Ez0 = 100;
		public static readonly double Hz0 = 100 / PhisCnst.Z0;
		public static readonly int BoundWidth0 = 30;
		public static readonly double G = 2;
		public static readonly int IntX = 100;

		public static double DelX, DelY, DelT, DtDivDx, DtDivDy, ScaleCoef;
		public static int SizeX, SizeY, Tn, BoundWidth;
		public static TModeType ModeType;

		public static ExtArr SigmaXCoeffs, SigmaYCoeffs, SigmaZCoeffs,
		  SigmaXSCoeffs, SigmaYSCoeffs, SigmaZSCoeffs,
		  OneDivSigmaX, OneDivSigmaY, OneDivSigmaXS, OneDivSigmaYS;

		public static ExtArr IntFModeEz, IntFModeHy;
		public static int SelfModeNumber;

		public static readonly string ValuesFile1Name = "Values1.txt";
		public static readonly string ValuesFile2Name = "Values2.txt";
		public static readonly string ReportFileName = "Report.txt";

		public static double BettaX, BettaY;

		static Common6()
		{
			BoundWidth = BoundWidth0;
			SigmaX = 2 * Math.PI * PhisCnst.Eps0 / 1000;
			SigmaY = 2 * Math.PI * PhisCnst.Eps0 / 1000;
			SigmaZ = 0;
			SigmaXS = SigmaX * PhisCnst.Mu0 / PhisCnst.Eps0;
			SigmaYS = SigmaY * PhisCnst.Mu0 / PhisCnst.Eps0;
			SigmaZS = 0;
			CoefG = G;
			SizeX = SizeX0;
			SizeY = SizeY0;
			Lx = Lx0;
			Ly = Ly0;
			DelT = DelT0;
			DelX = DelX0;
			DelY = DelY0;
			DtDivDx = DelT / DelX;
			DtDivDy = DelT / DelY;
			ModeType = TModeType.mtTE;
			InitialWave = TInitialWave.iwSin;
			InitialX1 = 50;
			InitialX2 = 150;
			InitialY1 = 0;
			InitialY2 = SizeY - 1;
			HalfPX = 4;
			HalfPY = 1;
			ExpX = 0.1;
			ExpY = 0.1;
			DrawGraphicsPoints = true;
			//DrawRecord.ToDraw = tdEachStep;
			//DrawRecord.ReadyToDraw = True;
			//DrawRecord.ObjectsSet = [doWave..doFourier];
			//Saving = [doWave..doFourier];
			WaveSaveCount = -1;
			CompSaveCount = -1;
			GraphSaveCount = -1;
			SaveOnActivePage = false;
			ToRewrite = true;
			AutoSave = false;
			AutoSaveTime = 1;
			ScaleCoef = 1.0;
			WhiteValue = 0;
			BlackValue = 1.50;
			//InitialStyleSet = [isFromMedium, isManual];
			FourX1 = 20;
			FourX2 = 40;

			//GPoints1 = TPoints.Create;
			//GPoints2 = TPoints.Create;
			//IntFPoints = TPoints.Create;
			//IntBPoints = TPoints.Create;
			//IntEnable = False;
			LastAdded = 0;
			LastAddedI = 0;
		}

		public static int LastAddedI { get; set; }

		public static int LastAdded { get; set; }

		public static int FourX2 { get; set; }

		public static int FourX1 { get; set; }

		public static double BlackValue { get; set; }

		public static double WhiteValue { get; set; }

		public static int AutoSaveTime { get; set; }

		public static bool AutoSave { get; set; }

		public static bool ToRewrite { get; set; }

		public static bool SaveOnActivePage { get; set; }

		public static int GraphSaveCount { get; set; }

		public static int CompSaveCount { get; set; }

		public static int WaveSaveCount { get; set; }

		public static bool DrawGraphicsPoints { get; set; }

		public static double ExpY { get; set; }

		public static double ExpX { get; set; }

		public static int HalfPY { get; set; }

		public static int HalfPX { get; set; }

		public static int InitialY2 { get; set; }

		public static int InitialY1 { get; set; }

		public static int InitialX2 { get; set; }

		public static int InitialX1 { get; set; }

		public static TInitialWave InitialWave { get; set; }

		public static double Ly { get; set; }

		public static double Lx { get; set; }

		public static double CoefG { get; set; }

		public static double SigmaZS { get; set; }

		public static double SigmaYS { get; set; }

		public static double SigmaXS { get; set; }

		public static double SigmaZ { get; set; }

		public static double SigmaY { get; set; }

		public static double SigmaX { get; set; }

		public static double ColorByValue(TFieldType FieldType, double Value)
		{
			var Max = BlackValue * GetMaxValue(FieldType);
			var Min = WhiteValue * GetMaxValue(FieldType);

			if (Math.Abs(Value) >= Max)
				throw new NotImplementedException();
				//return clBlack;
			if (Math.Abs(Value) <= Min)
				throw new NotImplementedException();
				//return clWhite;
			throw new NotImplementedException();
			//return ColorArray[Math.Round(255*(Math.Abs(Value) - Min) /(Max - Min))];
		}

		private static double GetMaxValue(TFieldType FieldType)
		{
			switch (FieldType)
			{
					case TFieldType.ftEType:
						return PhisCnst.Ez0;
					case TFieldType.ftDType:
						return PhisCnst.Ez0*PhisCnst.Eps0*RegionList.Eps;
					case TFieldType.ftHType:
						return PhisCnst.Hz0;
					case TFieldType.ftBType:
						return PhisCnst.Hz0*PhisCnst.Mu0;
				default:
						return 0.1;
			}
			
		}
	}

	public enum TModeType
	{
		mtTE,
		mtTM
	}

	public enum TFieldType
	{
		ftEType,
		ftDType,
		ftHType,
		ftBType
	}

	public enum TCompCoord
	{
		ccHoriz, ccVert
	}

	public enum TProcessState
	{
		psStoped, psRuning, psPaused
	}

	public enum TInitialWave
	{
		iwSin, iwGauss
	}

	public enum TToDraw
	{
		tdEachStep, tdOnStep, tdOnTime
	}

	public enum TDrawObjects
	{
		doWave, doComponents, doGraphics, doFourier
	}

	public enum TInitialStyle
	{
		isFromMedium, isManual
	}



	public class TFieldPointercs
	{
		public object Field;
		public TFieldType FieldType;
		public bool Enable;
	}

	public class TDrawRecord
	{
		public bool ReadyToDraw;
		public List<TDrawObjects> FieldType;
		public TToDraw ToDraw;
		public int StepCouunt;
		public object Time;

	}
}
