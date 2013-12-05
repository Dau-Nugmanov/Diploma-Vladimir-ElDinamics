using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ElDinamicCalc
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
	        try
	        {
				RegionList list = new RegionList();
				list.LoadFromFile(
					@"F:\Users\Nugmanov\Dropbox\Дипломки\Diploma-Vladimir-ElDinamics\ElDinamicCalc\ElDinamicCalc\Manenkov.mdm");

				TThr tr = new TThr();
				while (Common6.Tn < 10000)
				{
					tr.Execute();
				}
	        }
	        catch (Exception ex)
	        {
		        throw;
	        }
           
        }
    }
}
