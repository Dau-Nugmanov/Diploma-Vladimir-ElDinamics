namespace ElDinamicCalc
{
	public static class Regions
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