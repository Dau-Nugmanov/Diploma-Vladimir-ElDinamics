using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ElDinamicCalc
{
    public class ExtArr : ICloneable
    {
        //        {Модуль описывает двумерный динамический массив (TExtArray)
        //типа AValuesType размера ASizeX на ASizeY с вырезом размера
        //AIdleX на AIdleY, смещенным от границ на AShiftX и AShiftY,
        //индексация начинается с AStartX и AStartY

        //     *******************************    ^
        //     *    *     *   ^       *    * *    |
        //     *  *     *   SiftY   *    *   *    |
        //     *      *    *  ^   *    *     *    |
        //     *    *    * ********* * ^   * *    |
        //     * <-ShiftX->*       *   | *   *  SizeY
        //     *     *     *       * IdleY   *    |
        //     *   *     * *       *   |    **    |
        //     * *     *   *********   ^  *  *    |
        //     *     *     <-IdleX->    *    *    |
        //     *******************************    ^
        //     <----------SizeX-------------->

        //При обращении к несуществующему элементу возвращается 0
        //Памяти выделяется только на существующие элементы :
        //(SizeX*SizeY-IdleX*IdleY)*SizeOf(ValueType)}

        public int SizeX, SizeY, ShiftX, ShiftY, IdleX, IdleY, StartX, StartY;
        private decimal[] FValues;

        public ExtArr(int aSizeX, int aSizeY, int aShiftX, int aShiftY, int aIdleX, int aIdleY, int aStartX, int aStartY)
        {
            SizeX = aSizeX;
            SizeY = aSizeY;
            StartX = aStartX;
            StartY = aStartY;
            IdleX = aIdleX;
            IdleY = aIdleY;
            ShiftX = aShiftX;
            ShiftY = aShiftY;

            if (IdleX > SizeX)
            {
                ShiftX = 0;
                IdleX = SizeX;
            }
            if (IdleY > SizeY)
            {
                ShiftY = 0;
                IdleY = SizeY;
            }
            if (ShiftX + IdleX > SizeX)
            {
                ShiftX = SizeX - IdleX;
            }
            if (ShiftY + IdleY > SizeY)
            {
                ShiftY = SizeY - IdleY;
            }
            if (ShiftX < 0)
            {
                ShiftX = 0;
            }
            if (ShiftY < 0)
            {
                ShiftY = 0;
            }
            if (IdleX < 0)
            {
                IdleX = 0;
            }
            if (IdleY < 0)
            {
                IdleY = 0;
            }
            if (SizeX <= 0)
            {
                SizeX = 1;
            }
            if (SizeY <= 0)
            {
                SizeY = 1;
            }

			var Length = SizeX * SizeY - IdleX * IdleY;
			FValues = new decimal[Length];
        }

        public int GetIndex(int x, int y)
        {
            if ((x - StartX < 0) || (x - StartX >= SizeX))
                return -1;
            if ((y - StartY < 0) || (y - StartY >= SizeY))
                return -1;

            if ((x - StartX >= ShiftX) && (x - StartX < ShiftX + IdleX)
                && (y - StartY >= ShiftY) && (y - StartY < ShiftY + IdleY))
                return -1;

            if (y - StartY < ShiftY)
            {
                return (x - StartX) + (y - StartY) * SizeX;
            }

            if ((y - StartY >= ShiftY) && (y - StartY < ShiftY + IdleY))
            {
                if (x < ShiftX)
                    return ShiftY * IdleX + (x - StartX) + (y - StartY) * (SizeX - IdleX);
                
                return ShiftY * IdleX + (x - StartX) + (y - StartY) * (SizeX - IdleX) - IdleX;
            }

            if(y - StartY >= ShiftY + IdleY)
                return (x - StartX) + (y - StartY) * SizeX - IdleX * IdleY;

            return -1;
        }

		public decimal this[int x, int y]
        {
            get
            {
                var ind = GetIndex(x, y);
                return ind >= 0 ? FValues[ind] : 0;
            }
            set
            {
                var Ind = GetIndex(x, y);
                if (Ind >= 0)
                {
                    FValues[Ind] = value;
                }
            }
        }

	    public object Clone()
	    {
		    var res = new ExtArr(SizeX, SizeY, ShiftX, ShiftY, IdleX, IdleY, StartX, StartY);
			FValues.CopyTo(res.FValues, 0);
		    return res;
	    }
    }
}
