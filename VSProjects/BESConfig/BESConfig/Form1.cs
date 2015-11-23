using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BESConfig
{
    public partial class Form1 : Form
    {
        
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            if (!CheckForestName(textBox1.Text) )
            {
                MessageBox.Show("Forest name contains illegal characters.", "Error!");
                return;
            }
            if (!CheckForestName2(textBox1.Text))
            {
                MessageBox.Show("Forest name should be a proper DNS name. For example, 'contoso.com' rather than just 'contoso' .", "Error!");
                return;
            }
            if (!CheckNetBIOS(textBox2.Text))
            {
                MessageBox.Show("NetBIOS name contains illegal characters.", "Error!");
                return;
            }
            if (!ChecknetBIOSName2(textBox2.Text))
            {
                MessageBox.Show("Incorrect NetBIOS name. Ensure you have a valid name from 1 to 15 characters in length.", "Error!");
                return;
            }
            if (textBox4.Text != textBox5.Text)
            {
                MessageBox.Show("Passwords don't match. Please double check your passwords.", "Error!");
                return;
            }
            if (textBox4.Text.Length == 0)
            {
                MessageBox.Show("Please enter a valid password.", "Error!");
                return;
            }
            if (!CheckPasswordSecure(textBox4.Text))
            {
                MessageBox.Show("Please ensure you have a secure password, containing at least one uppercase character, one lowercase character, and at lease one number or valid symbol.", "Error");
                return;
            }
            else
            {
                string dom = textBox1.Text;
                string netbios = textBox2.Text;

                string password = textBox4.Text;

                string adminuser = System.Environment.UserName;
                CreateUnattendFile(dom, netbios, adminuser, password);
                this.Close();

            }
        }

        private bool CheckPasswordSecure(string text)
        {
            if (IsPasswordValid(text) & (text.Length > 5))
            {
                return true;

            }
            else
                return false;

        }


        public bool IsPasswordValid(string password)
        {
            bool result = true;
            const string lower = "abcdefghijklmnopqrstuvwxyz";
            const string upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const string digits = "0123456789";
            string allChars = lower + upper + digits;
            //Check Lowercase if rule is enforced

                result &= (password.IndexOfAny(lower.ToCharArray()) >= 0);
                result &= (password.IndexOfAny(upper.ToCharArray()) >= 0);
            result &= ((password.IndexOfAny(digits.ToCharArray()) >= 0) | (password.Trim(allChars.ToCharArray()).Length > 0));

            if (password.Contains("'")) result= false;
            if (password.Contains("%")) result = false;
            if (password.Contains("\"")) result = false;
            if (password.Contains(" ")) result = false;

            return result;
        }
        private bool ChecknetBIOSName2(string text)
        {
            if (text.Length < 1)
            {
                //MessageBox.Show("Cannot have a blank NetBIOS Name.", "Error!");
                return false;
            }
            if (text.Length > 15)
            {
                return false;
            }
            return true;
                
                
        }

        private bool CheckForestName2(string text)
        {
            if (text.Contains("."))
            {
                return true;
            }
            else
                return false;
        }

        public bool CheckNetBIOS(string name)
        {

            string unallowed = @"\/:*?<>|,.~:!@#$%^&'(){}_ ";

            //unallowed += @""";

            bool result = true;

            foreach (char c in unallowed)
            {
                if (name.Contains(c)) result = false;
            }
            return result;

        }

        public bool CheckForestName(string name)
        {

            string unallowed = @"\/:*?<>|,~:!@#$%^&'(){}_ ";
            
            //unallowed+= @""";


            bool result = true;

            foreach (char c in unallowed)
            {
                if (name.Contains(c)) result = false;
            }

            return result;


            
        }

        private void CreateUnattendFile(string dom, string netbios, string adminuser , string password)
        {
           // throw new NotImplementedException();
            string cmdline = @"dcpromo /unattend /InstallDns:yes /dnsOnNetwork:yes /replicaOrNewDomain:domain /newDomain:forest ";
            cmdline += @"/newDomainDnsName:" + dom + " /DomainNetbiosName:" + netbios +" ";
            cmdline += @"/databasePath:""c:\Windows\ntds"" /logPath:""c:\Windows\ntdslogs"" /sysvolpath:""c:\Windows\sysvol"" ";
            cmdline += @"/safeModeAdminPassword:" + password + " /forestLevel:2 /domainLevel:2 /rebootOnCompletion:yes";

            System.IO.File.WriteAllText(@"C:\blackberry\scr\dompromo.cmd", cmdline);

            string envstring = "set adminname=" + adminuser + System.Environment.NewLine;
            envstring += "set adminpw=" + password + System.Environment.NewLine;
            envstring += "set netbiosname=" + netbios + System.Environment.NewLine;

            System.IO.File.WriteAllText(@"c:\blackberry\scr\envvars.cmd", envstring);

            string firstbootdirection = "call domfirststep.cmd";
            System.IO.File.WriteAllText(@"c:\blackberry\scr\go.cmd", firstbootdirection );

            Application.Exit();




            //            var result= MessageBox.Show("About to configure the new Forest. Your System will reboot when complete.", "Information", MessageBoxButtons.OKCancel);


            //i

            //            if (result == DialogResult.OK)
            //            {

            //                    Process P = new Process();
            //                    P.StartInfo.UseShellExecute = true;
            //                    P.StartInfo.RedirectStandardOutput = false;
            //                    P.StartInfo.FileName = @"c:\blackberry\dompromo.cmd";
            //                    P.StartInfo.WorkingDirectory = @"c:\blackberry";
            //                    P.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
            //                    P.Start();


            //                completed = true;
            //            }


            //Process P = new Process();
            //P.StartInfo.UseShellExecute = true;
            //P.StartInfo.RedirectStandardOutput = false;
            //P.StartInfo.FileName = @"direr.cmd";
            //P.StartInfo.WorkingDirectory = @"c:\";
            //P.StartInfo.Arguments = @"/s";
            //P.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
            //P.Start();

            //MessageBox.Show(cmdline);
            ///  
        }

        private void textBox1_Leave(object sender, EventArgs e)
        {
            if (textBox2.Text.Length == 0)
            {

                string dnsstring = textBox1.Text;
                if (dnsstring.Length == 0) return;
                if (!dnsstring.Contains(".")) return;

                int pos = dnsstring.IndexOf(".");
                if (pos < 15)
                {
                    string netbiosname = dnsstring.Split('.')[0];
                    textBox2.Text = netbiosname;
                }
                else
                {
                    textBox2.Text = dnsstring.Substring(0, 15);
                }
            }
        }
    }
}
