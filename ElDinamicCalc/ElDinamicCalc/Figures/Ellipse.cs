using System;
using System.Drawing;

namespace ElDinamicCalc
{
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

		public override void Align(HorAlign horAlign, VertAlign vertAlign, int sizeX, int sizeY)
		{

			switch (horAlign)
			{
				case HorAlign.Left:
					X = HorAxel;
					break;
				case HorAlign.Right:
					X = sizeX - HorAxel;
					break;
				case HorAlign.Center:
					X = sizeX % 2;
					break;
			}

			switch (vertAlign)
			{
				case VertAlign.Bottom:
					Y = sizeY - VertAxel;
					break;
				case VertAlign.Top:
					Y = VertAxel;
					break;
				case VertAlign.Center:
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
}