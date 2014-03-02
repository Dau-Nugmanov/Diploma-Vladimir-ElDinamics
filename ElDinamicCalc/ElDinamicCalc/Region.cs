using System;
using System.Drawing;
using System.IO;

namespace ElDinamicCalc
{
	public class Region
	{
		public Figure Figure { get; set; }

		public MatterType MatterType { get; set; }

		public decimal Eps { get; set; }

		public decimal Eps2 { get; set; }

		public void DrawContour(Graphics graph, int height, int width)
		{
			Figure.DrawContour(graph, height, width);
		}
		
		public bool LoadFromStream(BinaryReader reader)
		{
			try
			{
				MatterType = (MatterType)reader.ReadByte();
				Eps = reader.ReadExtended();
				Eps2 = reader.ReadExtended();
				var shape = (ContourShape)reader.ReadByte();
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

		private Figure CreateFigure(ContourShape shape)
		{
			switch (shape)
			{
				case ContourShape.Rect:
					return new Rect();
				case ContourShape.Circle:
					return new Circle();
				case ContourShape.Ellipse:
					return new Ellipse();
				case ContourShape.HalfSpace:
					return new HalfSpace();
				default:
					throw new NotImplementedException();
			}
		}
	}
}