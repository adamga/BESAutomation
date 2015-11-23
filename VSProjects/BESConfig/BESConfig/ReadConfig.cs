using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace BESConfig
{
    class ReadConfig
    {

        public ReadConfig()
        { }

        public string configfile { get; set; }
        public string tiltebartext { get; set; }
        public string MessageText { get; set; }

        public void go()
        {
            XmlDocument thedoc = new XmlDocument();
            thedoc.Load(configfile);

        }


    }
}
