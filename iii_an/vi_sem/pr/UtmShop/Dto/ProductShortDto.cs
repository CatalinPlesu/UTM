using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UtmShop.Dto
{
    public class ProductShortDto
    {
        public long Id { get; set; }
        public string Title { get; set; }
        public Decimal Price { get; set; }
        public long CategoryId { get; set; }
    }
}
