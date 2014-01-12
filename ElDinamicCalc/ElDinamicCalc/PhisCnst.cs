namespace ElDinamicCalc
{
	/// <summary>
	///     {Модуль, содержащий основные физические константы}
	/// </summary>
	public class PhisCnst
	{
		public const decimal Pi = ExtMath.Pi;
		public const decimal Eps0 = 8.85e-12m;
		public const decimal Mu0 = 4*Pi*1e-7m;
		public const decimal C = 3e8m;
		public const decimal Z0 = 377;


		public const decimal EpsDivMu = Eps0/Mu0;
		public const decimal MuDivEps = Mu0/Eps0;

		public const decimal Ez0 = 100;
		public const decimal Hz0 = Ez0/Z0;
	}
}