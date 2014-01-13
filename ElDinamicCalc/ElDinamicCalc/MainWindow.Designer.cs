namespace ElDinamicCalc
{
	partial class MainWindow
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.button1 = new System.Windows.Forms.Button();
			this.drawPanel = new System.Windows.Forms.Panel();
			this.tbStep = new System.Windows.Forms.TextBox();
			this.timerDraw = new System.Windows.Forms.Timer(this.components);
			this.tbQueueCount = new System.Windows.Forms.TextBox();
			this.rbSingleThread = new System.Windows.Forms.RadioButton();
			this.gbThreading = new System.Windows.Forms.GroupBox();
			this.rbMultiThread = new System.Windows.Forms.RadioButton();
			this.gbThreading.SuspendLayout();
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(712, 732);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(75, 23);
			this.button1.TabIndex = 0;
			this.button1.Text = "button1";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// drawPanel
			// 
			this.drawPanel.Location = new System.Drawing.Point(13, 13);
			this.drawPanel.Name = "drawPanel";
			this.drawPanel.Size = new System.Drawing.Size(774, 484);
			this.drawPanel.TabIndex = 1;
			// 
			// tbStep
			// 
			this.tbStep.Location = new System.Drawing.Point(686, 525);
			this.tbStep.Name = "tbStep";
			this.tbStep.Size = new System.Drawing.Size(100, 20);
			this.tbStep.TabIndex = 2;
			// 
			// timerDraw
			// 
			this.timerDraw.Enabled = true;
			this.timerDraw.Interval = 1;
			this.timerDraw.Tick += new System.EventHandler(this.timerDraw_Tick);
			// 
			// tbQueueCount
			// 
			this.tbQueueCount.Location = new System.Drawing.Point(686, 564);
			this.tbQueueCount.Name = "tbQueueCount";
			this.tbQueueCount.Size = new System.Drawing.Size(100, 20);
			this.tbQueueCount.TabIndex = 3;
			// 
			// rbSingleThread
			// 
			this.rbSingleThread.AutoSize = true;
			this.rbSingleThread.Checked = true;
			this.rbSingleThread.Location = new System.Drawing.Point(6, 19);
			this.rbSingleThread.Name = "rbSingleThread";
			this.rbSingleThread.Size = new System.Drawing.Size(105, 17);
			this.rbSingleThread.TabIndex = 4;
			this.rbSingleThread.TabStop = true;
			this.rbSingleThread.Text = "В одном потоке";
			this.rbSingleThread.UseVisualStyleBackColor = true;
			// 
			// gbThreading
			// 
			this.gbThreading.Controls.Add(this.rbMultiThread);
			this.gbThreading.Controls.Add(this.rbSingleThread);
			this.gbThreading.Location = new System.Drawing.Point(309, 531);
			this.gbThreading.Name = "gbThreading";
			this.gbThreading.Size = new System.Drawing.Size(200, 100);
			this.gbThreading.TabIndex = 5;
			this.gbThreading.TabStop = false;
			this.gbThreading.Text = "groupBox1";
			// 
			// rbMultiThread
			// 
			this.rbMultiThread.AutoSize = true;
			this.rbMultiThread.Location = new System.Drawing.Point(6, 42);
			this.rbMultiThread.Name = "rbMultiThread";
			this.rbMultiThread.Size = new System.Drawing.Size(93, 17);
			this.rbMultiThread.TabIndex = 5;
			this.rbMultiThread.Text = "Параллельно";
			this.rbMultiThread.UseVisualStyleBackColor = true;
			// 
			// MainWindow
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(799, 767);
			this.Controls.Add(this.gbThreading);
			this.Controls.Add(this.tbQueueCount);
			this.Controls.Add(this.tbStep);
			this.Controls.Add(this.drawPanel);
			this.Controls.Add(this.button1);
			this.Name = "MainWindow";
			this.Text = "MainWindowcs";
			this.gbThreading.ResumeLayout(false);
			this.gbThreading.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Panel drawPanel;
		private System.Windows.Forms.TextBox tbStep;
		private System.Windows.Forms.Timer timerDraw;
		private System.Windows.Forms.TextBox tbQueueCount;
		private System.Windows.Forms.RadioButton rbSingleThread;
		private System.Windows.Forms.GroupBox gbThreading;
		private System.Windows.Forms.RadioButton rbMultiThread;
	}
}