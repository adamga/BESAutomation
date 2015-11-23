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
    public partial class moreinfo : Form
    {
        public moreinfo()
        {
            InitializeComponent();
        }

        private void moreinfo_Load(object sender, EventArgs e)
        {
            string moreinfolink = System.IO.File.ReadAllText("moreinfolink.txt");
            webBrowser1.Navigate(moreinfolink);

        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
