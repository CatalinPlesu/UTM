using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UtmShop.Model;

namespace UtmShop.Dto.Profiles
{
    public class CategoryShortProfile : Profile
    {
        public CategoryShortProfile()
        {
            CreateMap<Category, CategoryShortDto>()
                .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Title))
                .ForMember(dest => dest.ItemsCount, opt => opt.MapFrom(src => src.Products.Count));
        }
    }
}
