using System;
using System.Collections.Generic;
using System.Text;

namespace Util.Models
{
    public class Book : DbDocument
    {

        public string Title { get; set; }
        public string Author { get; set; }
        public List<string>Topics { get; set; }
        public decimal? Price { get; set; }
        public string Description { get; set; }
        
    }
}
