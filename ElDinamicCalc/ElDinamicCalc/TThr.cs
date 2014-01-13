using System;
using System.Linq;
using System.Threading;

namespace ElDinamicCalc
{
	public class TThr
	{
		private static readonly Proc6 proc = new Proc6();
		
		private bool isMultiThreading;
		private void DoWork(object state)
		{
			if (isMultiThreading) ThreadPool.QueueUserWorkItem(Init);
			while (Common6.Tn < 10000)
			{
				if (isMultiThreading) Thread.Sleep(90);
				//using (TextWriter writer = new StreamWriter(@"d:\test2.txt", true))
				//{
				//	var oldDzN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);
				//	var oldEzN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);
				//	var oldBxN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);
				//	var oldByN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);
				//	var oldHxN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);
				//	var oldHyN = new ExtArr(Common6.SizeX0 + 2, Common6.SizeY0 + 2, 0, 0, 0, 0, -1, -1);

				//	decimal newDzN;
				//	decimal newEzN;
				//	decimal newBxN;
				//	decimal newByN;
				//	decimal newHxN;
				//	decimal newHyN;

				//writer.WriteLine("Tn=" + Common6.Tn);
				for (int i = 0; i < Common6.SizeX; i++)
					for (int j = 0; j < Common6.SizeY; j++)
					{
						if (((i + j + 2)%2 == 0) && ((Common6.Tn + 2)%2 == 0))
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
						if (((i + j + 2)%2 == 1) && ((Common6.Tn + 2)%2 == 1))
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

						//newDzN = Math.Round(Common6.DzN[i, j], 15);
						//newEzN = Math.Round(Common6.EzN[i, j], 15);
						//newBxN = Math.Round(Common6.BxN[i, j], 15);
						//newByN = Math.Round(Common6.ByN[i, j], 15);
						//newHxN = Math.Round(Common6.HxN[i, j], 15);
						//newHyN = Math.Round(Common6.HyN[i, j], 15);

						//if (newDzN != oldDzN[i, j])
						//	writer.WriteLine("DzN[" + i + ", " + j + "] = " + newDzN.ToString("0.####################"));

						//if (newEzN != oldEzN[i, j])
						//	writer.WriteLine("EzN[" + i + ", " + j + "] = " + newEzN.ToString("0.####################"));

						//if (newBxN != oldBxN[i, j])
						//	writer.WriteLine("BxN[" + i + ", " + j + "] = " + newBxN.ToString("0.####################"));

						//if (newByN != oldByN[i, j])
						//	writer.WriteLine("ByN[" + i + ", " + j + "] = " + newByN.ToString("0.####################"));

						//if (newHxN != oldHxN[i, j])
						//	writer.WriteLine("HxN[" + i + ", " + j + "] = " + newHxN.ToString("0.####################"));

						//if (newHyN != oldHyN[i, j])
						//	writer.WriteLine("HyN[" + i + ", " + j + "] = " + newHyN.ToString("0.####################"));

						//writer.Flush();

						//oldDzN[i, j] = newDzN;
						//oldEzN[i, j] = newEzN;
						//oldBxN[i, j] = newBxN;
						//oldByN[i, j] = newByN;
						//oldHxN[i, j] = newHxN;
						//oldHyN[i, j] = newHyN;
					}
				proc.Next();
				Common6.Tn++;
				Common6.WaveF = Common6.Ez;
				Common6.DrawQueue.Enqueue(Common6.WaveF.Clone() as ExtArr);
				//}
			}
		}

		private void Init(object state)
		{
			while (true)
			{
				var source = Enumerable.Range(1, 10000)
				.Select(n => n * n * n);

				var evenNums = source
					.AsParallel()
					.Select(n => Math.Pow(Math.Log10(Math.Pow(n, 2) / Math.PI), 5) / (Math.PI * Math.PI))
					.ToArray();
			}
		}

		public void Execute(bool isMultiThreading)
		{
			this.isMultiThreading = isMultiThreading;
			ThreadPool.QueueUserWorkItem(DoWork);
		}
	}
}