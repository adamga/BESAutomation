using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;

namespace SetupMonitor
{
    public partial class Form1 : Form

    {

        int value = 0;
        public Form1()
        {
            InitializeComponent();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            value++;
            if (value > 100) value = 1;
            progressBar1.Value = value;

            if (System.IO.File.Exists(@"c:\blackberry\adsetupdone.txt"))
            {
                timer1.Enabled = false;
                timer2.Enabled = true;

                textBox1.Text = "            Restarting...";
                progressBar1.Visible = false;
            }
                

        }

        public void rebootsystem()
        {
            
            //MessageBox.Show("restart");
            System.Diagnostics.Process.Start("shutdown.exe", "/r /t 30");         
            //System.Diagnostics.Process.Start("shutdown.exe", "/i");
            Application.Exit();


        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            rebootsystem();

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
          //  Form1.ActiveForm.Text = ConfigurationManager.AppSettings["titlebartext"];


        }
    }
}
