using System;
using System.IO;

namespace ElDinamicCalc
{
	public abstract class Field
	{
		public InitialFieldType FieldType { get; set; }

		public int SizeOfX { get; set; }
		public int SizeOfY { get; set; }
		public int StartX { get; set; }
		public int StartY { get; set; }
		public int HalfX { get; set; }
		public int HalfY { get; set; }
		public decimal BettaX { get; set; }
		public decimal BettaY { get; set; }

		public void SetField(int sizeX, int sizeY, int startX, int startY,
			int halfX, int halfY)
		{
			SizeOfX = sizeX;
			SizeOfY = sizeY;
			StartX = startX;
			StartY = startY;
			HalfX = halfX;
			HalfY = halfY;
			BettaX = ExtMath.Pi / SizeOfX * HalfX / RegionList.DelX;
			BettaY = ExtMath.Pi / SizeOfY * HalfY / RegionList.DelY;
		}

		public abstract void FillEx(ExtArr eX);
		public abstract void FillEy(ExtArr eY);
		public abstract void FillEz(ExtArr eZ);
		public abstract void FillDx(ExtArr dX);
		public abstract void FillDy(ExtArr dY);
		public abstract void FillDz(ExtArr dZ);
		public abstract void FillBx(ExtArr bX);
		public abstract void FillBy(ExtArr bY);
		public abstract void FillBz(ExtArr bZ);
		public abstract void FillHx(ExtArr hX);
		public abstract void FillHy(ExtArr hY);
		public abstract void FillHz(ExtArr hZ);
		public abstract void FillEzMax(ExtArr eZ);
		public abstract void FillHyMax(ExtArr hY);

		public void SaveToStream(MemoryStream stream)
		{
			//Stream.WriteBuffer(FFieldType, SizeOf(FieldType));
			//Stream.WriteBuffer(FSizeOfX, SizeOf(Integer));
			//Stream.WriteBuffer(FSizeOfY, SizeOf(Integer));
			//Stream.WriteBuffer(FStartX, SizeOf(Integer));
			//Stream.WriteBuffer(FStartY, SizeOf(Integer));
			//Stream.WriteBuffer(FHalfX, SizeOf(Integer));
			//Stream.WriteBuffer(FHalfY, SizeOf(Integer));
			//Stream.WriteBuffer(FBettaX, SizeOf(Extended));
			//Stream.WriteBuffer(FBettaY, SizeOf(Extended));
		}

		public virtual bool LoadFromStream(BinaryReader reader)
		{
			try
			{
				SizeOfX = reader.ReadInt32();
				SizeOfY = reader.ReadInt32();
				StartX = reader.ReadInt32();
				StartY = reader.ReadInt32();
				HalfX = reader.ReadInt32();
				HalfY = reader.ReadInt32();
				BettaX = reader.ReadExtended();
				BettaY = reader.ReadExtended();
			}
			catch (Exception)
			{
				return false;
			}
			return true;
		}

		public void Assign(Field source)
		{
			SizeOfX = source.SizeOfX;
			SizeOfY = source.SizeOfY;
			StartX = source.StartX;
			StartY = source.StartY;
			HalfX = source.HalfX;
			HalfY = source.HalfY;
			BettaX = source.BettaX;
			BettaY = source.BettaY;
		}

		public void Realloc(ref ExtArr fieldComp)
		{
			if ((fieldComp.SizeX < SizeOfX) || (fieldComp.SizeY < SizeOfY)
			    || (fieldComp.StartX > StartX) || (fieldComp.StartY > StartY))
			{
				fieldComp = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, StartX, StartY);
			}
		}
	}
}