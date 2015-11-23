using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BESConfig
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            if (radioButton2.Checked)
            {
                Form1 Check = new Form1();
                Check.Show();
                Hide();
                  
            }
            else
            {
                string firstbootdirection = "call configure.cmd";
                System.IO.File.WriteAllText(@"c:\blackberry\scr\go.cmd", firstbootdirection);
                Application.Exit();

            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string moreinfolink=System.IO.File.ReadAllText("moreinfolink.txt");

            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            moreinfo morefrm = new moreinfo();
            this.Visible = false;
            morefrm.ShowDialog();
            this.Visible = true;
   

        }
    }
}
