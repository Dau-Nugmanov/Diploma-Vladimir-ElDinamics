using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using ElDinamicCalc;

namespace Test
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{
		public MainWindow()
		{
			InitializeComponent();
		}

		private void Button_Click_1(object sender, RoutedEventArgs e)
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
