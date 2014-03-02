using System;
using System.Drawing;
using System.IO;

namespace ElDinamicCalc
{
	public class Region
	{
		public Figure Figure;
		public TMatterType MatterType;


		public decimal Eps { get; set; }

		public decimal Eps2 { get; set; }

		public void DrawContour(Graphics graph, int height, int width)
		{
			Figure.DrawContour(graph, height, width);
		}
		public Figure CreateFigure(TContourShape shape)
		{
			switch (shape)
			{
				case TContourShape.shRect:
					return new Rect();
				case TContourShape.shCircle:
					return new Circle();
				case TContourShape.shEllipse:
					return new Ellipse();
				case TContourShape.shHalfSpace:
					return new HalfSpace();
				default:
					throw new NotImplementedException();
			}
		}

		public bool LoadFromStream(BinaryReader reader)
		{
			try
			{
				MatterType = (TMatterType)reader.ReadByte();
				Eps = reader.ReadExtended();
				Eps2 = reader.ReadExtended();
				var shape = (TContourShape)reader.ReadByte();
				Figure = CreateFigure(shape);
				Figure.X = reader.ReadInt32();
				Figure.Y = reader.ReadInt32();
				int param = reader.ReadInt32();
				Figure.Param1 = param;
				param = reader.ReadInt32();
				Figure.Param2 = param;
			}
			catch (Exception)
			{
				return false;
			}

			return true;
		}
	}
}