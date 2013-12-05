using System;
using System.Collections;
using System.Drawing;
using System.IO;
using System.Net;
using System.Runtime.InteropServices;
using System.Windows;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;

namespace ElDinamicCalc
{
    public abstract class TFigure
    {
        protected TContourShape FShape;
        protected abstract int GetParam1();
        protected abstract int GetParam2();
        protected abstract void SetParam1(int Value);
        protected abstract void SetParam2(int Value);
        public int CoordX, CoordY;
		public int HorSize, VertSize;
        public TContourShape Shape { get; set; }
        public int Param1 { get; set; }
        public int Param2 { get; set; }
        public abstract Point Point1();
        public abstract Point Point2();
        public abstract bool Belong(int X, int Y);
        public abstract bool BelongContour(int X, int Y);
        public abstract void Align(THorAlign HorAlign, TVertAlign VertAlign, int SizeX, int SizeY);
    }

    public class TRect : TFigure
    {
        protected override int GetParam1()
        {
	        return HorSize;
        }

        protected override int GetParam2()
        {
	        return VertSize;
        }

        protected override void SetParam1(int Value)
        {
            if (HorSize == Value) 
				return;
			HorSize = Value;
        }

        protected override void SetParam2(int Value)
        {
            if (VertSize == Value)
				return;
			VertSize = Value;
        }

        public override Point Point1()
        {
            return new Point(CoordX, CoordY);
        }

        public override Point Point2()
        {
			return new Point(CoordX + HorSize, CoordY+ VertSize);
        }

        public override bool Belong(int X, int Y)
        {
            return (X >= CoordX) && (X < CoordX + HorSize) &&
				(Y >= CoordY) && (Y < CoordY + VertSize);
        }

        public override bool BelongContour(int X, int Y)
        {
             return (X == CoordX) || (X == CoordX + HorSize) ||
				(Y == CoordY) || (Y == CoordY + VertSize);
        }

        public override void Align(THorAlign HorAlign, TVertAlign VertAlign, int SizeX, int SizeY)
        {
			switch (HorAlign)
	        {
			        case THorAlign.haLeft:
			        CoordX = 0;
					break;
					case THorAlign.haRight:
					CoordX = SizeX - HorSize;
					break;
					case THorAlign.haCenter:
					CoordX = SizeX % 2 - HorSize % 2;
					break;

	        }
	        switch (VertAlign)
	        {
			        case TVertAlign.vaBottom:
					CoordY = SizeY - VertSize;
					break;
					case TVertAlign.vaTop:
					CoordY = 0;
					break;
					case TVertAlign.vaCenter:
					CoordY = SizeY % 2 - VertSize % 2;
					break;
	        }
        }
    }

    //    {TRegion :
    //методы :
    //  CreateFigure - придает объекту форму, определяемую AShape
    //  Assign - присвоить данному объекту все свойства объета Source
    //свойства :
    //  Eps - диэлектрическая проницаемость
    //  Figure - определяет геометрию объекта
    //  CoordX и CoordY - положение объекта
    //  MatterType - вещество (вакуум, диэлектрик или металл)}
    public class TRegion
    {
        private double FEps;
        private double FEps2;

        public TFigure Figure;
        public TMatterType MatterType;


        public double Eps
        {
            get;
            set;
        }

        public double Eps2
        {
            get;
            set;
        }

        public TFigure CreateFigure(TContourShape AShape)
        {
	        switch (AShape)
	        {
			        case TContourShape.shRect:
						return new TRect();
					case TContourShape.shCircle:
						throw new NotImplementedException();
					case TContourShape.shEllipse:
						throw new NotImplementedException();
					case TContourShape.shHalfSpace:
						throw new NotImplementedException();
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
                var Shape = (TContourShape)reader.ReadByte();
                Figure = CreateFigure(Shape);
                Figure.CoordX = reader.ReadInt32();
                Figure.CoordY = reader.ReadInt32();
                var Param = reader.ReadInt32();
                Figure.Param1 = Param;
                Param = reader.ReadInt32();
                Figure.Param2 = Param;
            }
            catch (Exception e)
            {
                return false;
            }

            return true;
        }

    }

    //    {TField
    //методы:
    //  CreateArrays - выделить память под массивы
    //  CreateTempArrays - выделить память под временные массивы
    //  FreeArrays - очистить память, выделенную под массивы
    //  FreeTempArrays - очистить память, выделенную под
    //    временные массивы
    //  StoreArrays - сохранить значения массивов во временные
    //  UnStoreArrays - вернуть значения массивов
    //  Realloc - изменить размеры поля (а значит перераспределить
    //    память)
    //свойства:
    //  SizeOfX и SizeOfY - размеры поля
    //  StartX и StartY - координаты начала области, в которой
    //    задается поле (верхняя левая точка)
    //  Ex, Ey, Ez, Dx, Dy, Dz, Hx, Hy, Hz, Bx, By, Bz - массивы
    //    значений компонент
    //  ExT, EyT, EzT, DxT, DyT, DzT, HxT, HyT, HzT, BxT, ByT, BzT -
    //    временные массивы (используются для сохранения значений
    //    основных при перераспределении памяти (Realloc))}
    public class TField
    {
        private int FSizeOfX, FSizeOfY, FStartX, FStartY;
        private ExtArr FEx, FEy, FEz, FDx, FDy, FDz, FBx, FBy, FBz, FHx, FHy, FHz;


        private bool ArraysExist;

        private void CreateArrays()
        {

        }
        private void CreateTempArrays()
        {

        }
        private void StoreArrays()
        {

        }
        private void UnStoreArrays()
        {

        }

        public int SizeOfX
        {
            get
            {
                return FSizeOfX;
            }
        }
        public int SizeOfY
        {
            get
            {
                return FSizeOfY;
            }
        }
        public int StartX
        {
            get
            {
                return FStartX;
            }
        }
        public int StartY
        {
            get
            {
                return FStartY;
            }
        }

    }

    public abstract class TField2
    {
        protected void Setup()
        {
        }


        public TInitialFieldType FieldType { get; set; }

        public int SizeOfX { get; set; }
        public int SizeOfY { get; set; }
        public int StartX { get; set; }
        public int StartY { get; set; }
        public int HalfX { get; set; }
        public int HalfY { get; set; }
        public double BettaX { get; set; }
        public double BettaY { get; set; }

        public void SetField(int ASizeX, int ASizeY, int AStartX, int AStartY, int AHalfX, int AHalfY)
        {
            SizeOfX = ASizeX;
            SizeOfY = ASizeY;
            StartX = AStartX;
            StartY = AStartY;
            HalfX = AHalfX;
            HalfY = AHalfY;
            BettaX = Math.PI / SizeOfX * HalfX / RegionList.DelX;
            BettaY = Math.PI / SizeOfY * HalfY / RegionList.DelY;
        }

        public abstract void FillEx(ExtArr Ex);
        public abstract void FillEy(ExtArr Ey);
        public abstract void FillEz(ExtArr Ez);
        public abstract void FillDx(ExtArr Dx);
        public abstract void FillDy(ExtArr Dy);
        public abstract void FillDz(ExtArr Dz);
        public abstract void FillBx(ExtArr Bx);
        public abstract void FillBy(ExtArr By);
        public abstract void FillBz(ExtArr Bz);
        public abstract void FillHx(ExtArr Hx);
        public abstract void FillHy(ExtArr Hy);
        public abstract void FillHz(ExtArr Hz);
        public abstract void FillEzMax(ExtArr Ez);
        public abstract void FillHyMax(ExtArr Hy);

        public void SaveToStream(MemoryStream Stream)
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
            catch (Exception e)
            {
                return false;
            }
            return true;
        }

        public void Assign(TField2 Source)
        {
            SizeOfX = Source.SizeOfX;
            SizeOfY = Source.SizeOfY;
            StartX = Source.StartX;
            StartY = Source.StartY;
            HalfX = Source.HalfX;
            HalfY = Source.HalfY;
            BettaX = Source.BettaX;
            BettaY = Source.BettaY;
        }

        public void Realloc(ref ExtArr FieldComp)
        {
            if ((FieldComp.SizeX < SizeOfX) || (FieldComp.SizeY < SizeOfY)
                || (FieldComp.StartX > StartX) || (FieldComp.StartY > StartY))
            {
                FieldComp = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, StartX, StartY);
            }
        }



    }



    public class RegionList
    {
        public static ExtArr EpsField { get; set; }
        public static ExtArr Eps2Field { get; set; }
        public static TBoundsType BoundsType { get; set; }
        public static TField2[] FieldList { get; set; }

        public static int SizeOfX, SizeOfY;
        public static double DelX, DelY, DelT;
        public static double Eps;
        public static int BoundsWidth;
        public static double Sigma;
        public static double CoefG;
        public static string Describ;

        public static List<TRegion> Regions = new List<TRegion>();
		public static List<TField2> Fields2 = new List<TField2>();

        public static int FileCode = 13031979;

        public bool LoadFromFile(string FileName)
        {
            try
            {
                using (var reader = new BinaryReader(File.OpenRead(FileName)))
                {
                    var code = reader.ReadInt32();
                    if (code != FileCode)
                    {
                        throw new Exception(FileName + " is not correct medium file");
                    }

                    SizeOfX = reader.ReadUInt16();
                    SizeOfY = reader.ReadUInt16();
                    DelX = reader.ReadExtended();
                    DelY = reader.ReadExtended();
                    DelT = reader.ReadExtended();
                    Eps = reader.ReadExtended();
                    BoundsType = (TBoundsType)reader.ReadByte();
                    BoundsWidth = reader.ReadInt32();
                    Sigma = reader.ReadExtended();
                    CoefG = reader.ReadExtended();

                    var newCount = reader.ReadByte();
                    if (newCount != 0)
                    {
                        for (int i = 0; i < newCount; i++)
                        {
                            var region = new TRegion();
                            if (!region.LoadFromStream(reader))
                                return false;

                            Regions.Add(region);
                        }
                    }
                    SetSetEpsField();


                    newCount = reader.ReadByte();
                    if (newCount != 0)
                    {
                        for (int i = 0; i < newCount; i++)
                        {
                            var FieldType = (TInitialFieldType)reader.ReadByte();

                            TField2 Field;
                            switch (FieldType)
                            {
                                case TInitialFieldType.ftSin:
                                    Field = new SinField();
                                    break;
                                case TInitialFieldType.ftGauss:
                                    Field = new GaussField();
                                    break;
                                case TInitialFieldType.ftRectSelf:
                                    Field = new RectSelfField();
                                    break;
                                case TInitialFieldType.ftRectSelf2:
                                    Field = new RectSelfField2();
                                    break;
                                default:
                                    throw new Exception();
                            }
                            Field.LoadFromStream(reader);
                            Fields2.Add(Field);
                        }
                    }
	                try
	                {
						var Len = reader.ReadInt32();
						if (Len != 0)
						{
							var tempDescrib = reader.ReadChars(Len);
							if (tempDescrib != null)
								Describ = Convert.ToString(tempDescrib);
						}
	                }
	                catch (Exception e)
	                {
		                
		                throw;
	                }
	                

                }

            }
            catch (Exception e)
            {

                throw;
            }
            return true;
        }

        private void SetSetEpsField()
        {
            EpsField = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, 0, 0);
            Eps2Field = new ExtArr(SizeOfX, SizeOfY, 0, 0, 0, 0, 0, 0);

            for (int i = 0; i < SizeOfX; i++)
                for (int j = 0; j < SizeOfY; j++)
                {
                    EpsField[i, j] = Eps;
                    for (int k = 0; k < Regions.Count; k++)
                    {
                        if (Regions[k].Figure.Belong(i, j))
                        {
                            EpsField[i, j] = Regions[k].Eps;
                            Eps2Field[i, j] = Regions[k].Eps2;
                            break;
                        }
                    }
                    if (BoundsType == TBoundsType.btMetall)
                    {
                        if (i == 0 || i == SizeOfX || j == 0 || j == SizeOfY)
                            EpsField[i, j] = 0;
                    }
                }

        }
    }

    public class RectSelfField2 : TField2
    {
        public override void FillEx(ExtArr Ex)
        {
            throw new NotImplementedException();
        }

        public override void FillEy(ExtArr Ey)
        {
            throw new NotImplementedException();
        }

        public override void FillEz(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillDx(ExtArr Dx)
        {
            throw new NotImplementedException();
        }

        public override void FillDy(ExtArr Dy)
        {
            throw new NotImplementedException();
        }

        public override void FillDz(ExtArr Dz)
        {
            throw new NotImplementedException();
        }

        public override void FillBx(ExtArr Bx)
        {
            throw new NotImplementedException();
        }

        public override void FillBy(ExtArr By)
        {
            throw new NotImplementedException();
        }

        public override void FillBz(ExtArr Bz)
        {
            throw new NotImplementedException();
        }

        public override void FillHx(ExtArr Hx)
        {
            throw new NotImplementedException();
        }

        public override void FillHy(ExtArr Hy)
        {
            throw new NotImplementedException();
        }

        public override void FillHz(ExtArr Hz)
        {
            throw new NotImplementedException();
        }

        public override void FillEzMax(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillHyMax(ExtArr Hy)
        {
            throw new NotImplementedException();
        }
    }

    public class RectSelfField : TField2
    {
	    public override bool LoadFromStream(BinaryReader reader)
	    {
		    bool res;
		    try
		    {
			    res = base.LoadFromStream(reader);
			    if (res)
			    {
				    Q = reader.ReadExtended();
				    P = reader.ReadExtended();
				    R = reader.ReadExtended();
				    A = reader.ReadExtended();
				    B = reader.ReadExtended();
				    ModeNum = reader.ReadInt32();
				    RectNum = reader.ReadInt32();

				    Rect = RegionList.Regions[RectNum];
				    DelY = RegionList.DelY;
				    Eps = Rect.Eps;
				    EpsA = RegionList.EpsField[Rect.Figure.CoordX + Rect.Figure.Param1%2,
					    Rect.Figure.CoordY + Rect.Figure.Param2 + 2];

				    Sym = (EpsA == EpsB);
				    Size = Rect.Figure.Param2*DelY/2;
				    Betta = Math.Sqrt(Eps*Math.Pow(K, 2) - Math.Pow(Q, 2));
				    ZeroPoint = Rect.Figure.CoordY + Rect.Figure.Param2/2;
				    Odd = (ModeNum + 2)%2 == 1;
				    One = Convert.ToInt32(Odd)*2 - 1; //+-1
			    }
		    }
		    catch (Exception)
		    {
			    res = false;
		    }
		    return res;
	    }

	    public TRegion Rect { get; set; }

        public int RectNum { get; set; }

        public int ModeNum { get; set; }

        public double B { get; set; }

        public double A { get; set; }

        public double R { get; set; }

        public double P { get; set; }

        public double Q { get; set; }

        public double Betta { get; set; }

        public double K { get; set; }

        public double Size { get; set; }

        public int HalfY { get; set; }

        public double Eps { get; set; }

        public double EpsA { get; set; }

        public double EpsB { get; set; }

        public double DelY { get; set; }

        public bool Odd { get; set; }

        public bool Sym { get; set; }

        public int One { get; set; }

        public double ZeroPoint { get; set; }

        public double BettaY { get; set; }



        public double Bell(int i)
        {
            return Math.Sqrt(Math.Sin(Math.PI * (i - StartX) / SizeOfX));
        }

        public void CalculateParams()
        {
            double LeftRoot, RightRoot, Root;
            Func<double, double> Funct = null;
            LeftRoot = RightRoot = Root = 0;

            Odd = (ModeNum + 2) % 2 == 1;
            One = Convert.ToInt32(Odd) * 2 - 1;  //+-1

            EpsA = RegionList.EpsField[Rect.Figure.CoordX + Rect.Figure.Param1 % 2,
                Rect.Figure.CoordY - 1];
            EpsB = RegionList.EpsField[Rect.Figure.CoordX + Rect.Figure.Param1 % 2,
                Rect.Figure.CoordY + Rect.Figure.Param2 + 2];

            Sym = EpsA == EpsB;

             //CoefA = Size;
             // CoefP1 = Math.Sqrt(K) * (Eps - EpsA);
             // CoefP2 = 1;
             // CoefR1 = Math.Sqrt(K) * (Eps - EpsB);
             // CoefR2 = 1;
             // Coef1 = Math.Sqrt(K) * (Eps - EpsA);
             // Coef2 = 1;


            if (Sym)
            {
                if (Odd)
                {
                    Funct = Regions.FTan;
                }
                else
                {
					Funct = Regions.FCotan;
                }

                LeftRoot = (ModeNum - 1.5)*Math.PI/Size + 0.1;
                if (LeftRoot < 0)
                {
                    LeftRoot = 0.1;
                }

                RightRoot = (ModeNum - 0.5)*Math.PI/Size - 0.1;
                Root = (LeftRoot + RightRoot)/2;
            }
            else
            {
				Funct = Regions.FSelfMode;
                FindLeftRight(ref LeftRoot, ref RightRoot, ref Root);
            }

            if (!ExtMath.FindRoot(Funct, LeftRoot, RightRoot, Q, 0.1, 30000)
                || Math.Abs(Q) < 10)
            {
                if (!ExtMath.Newton(Funct, Root, Q, 0.0001, 30000) || Math.Abs(Q) < 10)
                {
                    throw  new Exception("Невозможно задать моду с такими параметрами");
                }
            }

	        if (Sym)
	        {
		        if (Odd)
		        {
			        P = -Q*Math.Tan(Q*Size);
			        A = PhisCnst.Ez0;
			        B = 0;
		        }
		        else
		        {
			        P = -Q*(1/Math.Tan(Q*Size));
			        A = 0;
			        B = PhisCnst.Ez0;
		        }
		        R = P;
	        }
	        else
	        {
				P = Regions.SelfModeP(Q);
				R = Regions.SelfModeR(Q);

		        if (Q + P*Math.Tan(Q*Size) != 0)
		        {
			        A = PhisCnst.Ez0/((P - Q*Math.Tan(Q*Size))
			                          /(Q + P*Math.Tan(Q*Size)) + 1);
		        }
		        else
		        {
			        A = 0;
		        }
		        B = PhisCnst.Eps0 - A;
	        }
			Betta = Math.Sqrt(Eps * Math.Pow(K, 2) - Math.Pow(Q, 2));
			SizeOfX = (int)Math.Round(HalfX / Betta * Math.PI / RegionList.DelX);
        }

        public void FindLeftRight(ref double leftRoot, ref double rightRoot, 
            ref double root)
        {
            leftRoot = (ModeNum - 1.5) * Math.PI / 2 / Size + 0.1;
            if (leftRoot < 0)
            {
                leftRoot = 0.1;
            }
            rightRoot = (ModeNum - 0.5) * Math.PI / 2 / Size - 0.1;

            var assim = K * Math.Sqrt((Eps - EpsA) * (Eps - EpsB) / (2 * Eps - EpsA - EpsB));

            if (assim > leftRoot && assim < rightRoot)
            {
                if (Math.Tan(2 * Size * assim) < 0)
                {
                    rightRoot = assim - 0.1;
                }
                else
                {
                    leftRoot = assim + 0.1;
                }
            }
            if (rightRoot > Math.Sqrt(Eps - EpsA) * K)
            {
                rightRoot = Math.Sqrt(Eps - EpsA) * K - 0.1;
            }
            if (rightRoot > Math.Sqrt(Eps - EpsB) * K)
            {
                rightRoot = Math.Sqrt(Eps - EpsB) * K - 0.1;
            }

            root = (leftRoot + rightRoot) / 2;
        }

        public override void FillEx(ExtArr Ex)
        {
            throw new NotImplementedException();
        }

        public override void FillEy(ExtArr Ey)
        {
            throw new NotImplementedException();
        }

        public override void FillEz(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillDx(ExtArr Dx)
        {
            throw new NotImplementedException();
        }

        public override void FillDy(ExtArr Dy)
        {
            throw new NotImplementedException();
        }

        public override void FillDz(ExtArr Dz)
        {
            throw new NotImplementedException();
        }

        public override void FillBx(ExtArr Bx)
        {
            throw new NotImplementedException();
        }

        public override void FillBy(ExtArr By)
        {
            throw new NotImplementedException();
        }

        public override void FillBz(ExtArr Bz)
        {
            throw new NotImplementedException();
        }

        public override void FillHx(ExtArr Hx)
        {
            throw new NotImplementedException();
        }

        public override void FillHy(ExtArr Hy)
        {
            throw new NotImplementedException();
        }

        public override void FillHz(ExtArr Hz)
        {
            throw new NotImplementedException();
        }

        public override void FillEzMax(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillHyMax(ExtArr Hy)
        {
            throw new NotImplementedException();
        }
    }

    public class GaussField : TField2
    {
        public override bool LoadFromStream(BinaryReader reader)
        {
            var res = base.LoadFromStream(reader);
            if (res)
            {
                ExpX = reader.ReadExtended();
                ExpY = reader.ReadExtended();
            }
            return res;
        }

        public double ExpY { get; set; }

        public double ExpX { get; set; }

        public override void FillEx(ExtArr Ex)
        {
            throw new NotImplementedException();
        }

        public override void FillEy(ExtArr Ey)
        {
            throw new NotImplementedException();
        }

        public override void FillEz(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillDx(ExtArr Dx)
        {
            throw new NotImplementedException();
        }

        public override void FillDy(ExtArr Dy)
        {
            throw new NotImplementedException();
        }

        public override void FillDz(ExtArr Dz)
        {
            throw new NotImplementedException();
        }

        public override void FillBx(ExtArr Bx)
        {
            throw new NotImplementedException();
        }

        public override void FillBy(ExtArr By)
        {
            throw new NotImplementedException();
        }

        public override void FillBz(ExtArr Bz)
        {
            throw new NotImplementedException();
        }

        public override void FillHx(ExtArr Hx)
        {
            throw new NotImplementedException();
        }

        public override void FillHy(ExtArr Hy)
        {
            throw new NotImplementedException();
        }

        public override void FillHz(ExtArr Hz)
        {
            throw new NotImplementedException();
        }

        public override void FillEzMax(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillHyMax(ExtArr Hy)
        {
            throw new NotImplementedException();
        }
    }

    public class SinField : TField2
    {
        public override void FillEx(ExtArr Ex)
        {
            throw new NotImplementedException();
        }

        public override void FillEy(ExtArr Ey)
        {
            throw new NotImplementedException();
        }

        public override void FillEz(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillDx(ExtArr Dx)
        {
            throw new NotImplementedException();
        }

        public override void FillDy(ExtArr Dy)
        {
            throw new NotImplementedException();
        }

        public override void FillDz(ExtArr Dz)
        {
            throw new NotImplementedException();
        }

        public override void FillBx(ExtArr Bx)
        {
            throw new NotImplementedException();
        }

        public override void FillBy(ExtArr By)
        {
            throw new NotImplementedException();
        }

        public override void FillBz(ExtArr Bz)
        {
            throw new NotImplementedException();
        }

        public override void FillHx(ExtArr Hx)
        {
            throw new NotImplementedException();
        }

        public override void FillHy(ExtArr Hy)
        {
            throw new NotImplementedException();
        }

        public override void FillHz(ExtArr Hz)
        {
            throw new NotImplementedException();
        }

        public override void FillEzMax(ExtArr Ez)
        {
            throw new NotImplementedException();
        }

        public override void FillHyMax(ExtArr Hy)
        {
            throw new NotImplementedException();
        }
    }

    public enum TBoundsType
    {
        btMetall,
        btAbsorb
    }

    public enum TContourShape { shRect, shCircle, shEllipse, shHalfSpace }
    public enum TOrientation { orLeft, orRight, orTop, orBottom }
    public enum TMatterType { mtVacuum, mtMetall, mtDielectr }
    public enum THorAlign { haLeft, haCenter, haRight, haNo }
    public enum TVertAlign { vaTop, vaCenter, vaBottom, vaNo }
    public enum TResizeDirection { rdLeft, rdRight, rdUp, rdDown }
    public enum TMouseAction { maMove, maResize }
    public enum TInitialFieldType { ftSin, ftGauss, ftRectSelf, ftRectSelf2 }

	public class Regions
	{
		public static double CoefA,
			Coef1,
			Coef2,
			CoefR1,
			CoefR2,
			CoefP1,
			CoefP2;

		public static double FTan(double X)
		{
			return X * Math.Tan(CoefA * X) - Math.Sqrt(Coef1 - Coef2 * Math.Pow(X, 2));
		}

		public static double FCotan(double X)
		{
			return -X * (1 / Math.Tan(CoefA * X)) - Math.Sqrt(Coef1 - Coef2 * Math.Pow(X, 2));
		}

		public static double SelfModeR(double Q)
		{
			return Math.Sqrt(CoefR1 - CoefR2 * Math.Pow(Q, 2));
		}

		public static double SelfModeP(double Q)
		{
			return Math.Sqrt(CoefP1 - CoefP2 * Math.Pow(Q, 2));
		}

		public static double FSelfMode(double X)
		{
			return  Math.Tan(2 * X * CoefA) - X * (SelfModeP(X) + SelfModeR(X))
				/ (Math.Pow(X, 2) - SelfModeP(X) * SelfModeR(X));
		}
	}
}

