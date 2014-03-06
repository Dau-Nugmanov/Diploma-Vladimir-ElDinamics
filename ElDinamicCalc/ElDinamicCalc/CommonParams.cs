using System.Collections.Generic;

namespace ElDinamicCalc
{
	public class CommonParams
	{
		public static readonly int SizeX0 = 201;
		public static readonly int SizeY0 = 101;
		public static readonly decimal DelX0 = 1e-6m;
		public static readonly decimal DelY0 = DelX0;
		public static readonly decimal Lx0 = DelX0*SizeX0;
		public static readonly decimal Ly0 = DelY0*SizeY0;
		public static readonly decimal DelT0 = DelX0/9/PhisicalConstants.C;
		public static readonly decimal Ez0 = 100;
		public static readonly decimal Hz0 = 100/PhisicalConstants.Z0;
		public static readonly int BoundWidth0 = 30;
		public static readonly decimal G = 2;
		public static readonly int IntX = 100;

		public static decimal DelX, DelY, DelT, DtDivDx, DtDivDy;
		public static int SizeX, SizeY, Tn, BoundWidth, PauseStepNum;
		public static int DrawStepNum = 1;
		public static int CellSize = 10;
		public static WorkMode WorkMode = WorkMode.SingleThread;
		
		public static ExtArr Ex,Ey,Ez,Dx,Dy,Dz,Hx,Hy,Hz,Bx,By,Bz,ExN,EyN,EzN,DxN,DyN,DzN,HxN,HyN,HzN,BxN,ByN,BzN;

		public static ExtArr Exy,Exz,Eyx,Eyz,Ezx,Ezy,Hxy,Hxz,Hyx,Hyz,Hzx,Hzy,ExyN,ExzN,
			EyxN,EyzN,EzxN,EzyN,HxyN,HxzN,HyxN,HyzN,HzxN,HzyN;

		public static ExtArr SigmaXCoeffs,SigmaYCoeffs,SigmaZCoeffs,SigmaXSCoeffs,SigmaYSCoeffs,
			SigmaZSCoeffs,OneDivSigmaX,OneDivSigmaY,OneDivSigmaXS,OneDivSigmaYS;

		public static ExtArr IntFModeEz, IntFModeHy;
		public static int SelfModeNumber;

		public static decimal BettaX, BettaY;

		public static Queue<DrawInfo> DrawQueue = new Queue<DrawInfo>();

		static CommonParams()
		{
			BoundWidth = BoundWidth0;
			SigmaX = 2*ExtMath.Pi*PhisicalConstants.Eps0/1000;
			SigmaY = 2*ExtMath.Pi*PhisicalConstants.Eps0/1000;
			SigmaZ = 0;
			SigmaXS = SigmaX*PhisicalConstants.Mu0/PhisicalConstants.Eps0;
			SigmaYS = SigmaY*PhisicalConstants.Mu0/PhisicalConstants.Eps0;
			SigmaZS = 0;
			CoefG = G;
			SizeX = SizeX0;
			SizeY = SizeY0;
			Lx = Lx0;
			Ly = Ly0;
			DelT = DelT0;
			DelX = DelX0;
			DelY = DelY0;
			DtDivDx = DelT/DelX;
			DtDivDy = DelT/DelY;
			InitialWave = InitialWave.Sin;
			InitialX1 = 50;
			InitialX2 = 150;
			InitialY1 = 0;
			InitialY2 = SizeY - 1;
			HalfPX = 4;
			HalfPY = 1;
			ExpX = 0.1m;
			ExpY = 0.1m;
			WhiteValue = 0m;
			BlackValue = 1.50m;
		}

		public static decimal BlackValue { get; set; }

		public static decimal WhiteValue { get; set; }
		public static decimal ExpY { get; set; }

		public static decimal ExpX { get; set; }

		public static int HalfPY { get; set; }

		public static int HalfPX { get; set; }

		public static int InitialY2 { get; set; }

		public static int InitialY1 { get; set; }

		public static int InitialX2 { get; set; }

		public static int InitialX1 { get; set; }

		public static InitialWave InitialWave { get; set; }

		public static decimal Ly { get; set; }

		public static decimal Lx { get; set; }

		public static decimal CoefG { get; set; }

		public static decimal SigmaZS { get; set; }

		public static decimal SigmaYS { get; set; }

		public static decimal SigmaXS { get; set; }

		public static decimal SigmaZ { get; set; }

		public static decimal SigmaY { get; set; }

		public static decimal SigmaX { get; set; }
		public static bool IntEnable { get; set; }
	}
}