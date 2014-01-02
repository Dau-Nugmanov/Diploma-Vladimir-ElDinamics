using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
    /// <summary>
    /// {Модуль, содержащий основные физические константы}
    /// </summary>
    public class PhisCnst
    {
		public const double Pi = Math.PI;
		public const double Eps0 = 8.85e-12;
		public const double Mu0 = 4 * Pi * 1e-7;
		public const double C = 3e8;
		public const double Z0 = 377;


		public const double EpsDivMu = Eps0 / Mu0;
		public const double MuDivEps = Mu0 / Eps0;

		public const double Ez0 = 100;
		public const double Hz0 = Ez0 / Z0;
    }
}
