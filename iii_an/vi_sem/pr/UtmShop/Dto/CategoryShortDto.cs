using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UtmShop.Dto
{
    public class CategoryShortDto
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public long ItemsCount { get; set; }
    }
}
