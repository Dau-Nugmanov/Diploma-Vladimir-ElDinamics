using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
	public class TThr
	{
		private static Proc6 proc = new Proc6();
		public void Calculate()
		{

		}

		public void Execute()
		{
			for (int i = 0; i < Common6.SizeX; i++)
				for (int j = 0; j < Common6.SizeY; j++)
				{
					if (((i + j + 2) % 2 == 0) && ((Common6.Tn + 2) % 2 == 0))
					{
						switch (Common6.ModeType)
						{
							case TModeType.mtTE:
								proc.ElectrTE(i, j);
								break;
							case TModeType.mtTM:
								proc.ElectrTM(i, j);
								break;
						}

					}
					if (((i + j + 2) % 2 == 1) && ((Common6.Tn + 2) % 2 == 1))
					{
						switch (Common6.ModeType)
						{
							case TModeType.mtTE:
								proc.MagnTE(i, j);
								break;
							case TModeType.mtTM:
								proc.MagnTM(i, j);
								break;
						}

					}
				}
			Common6.Tn++;
		}
	}
}
