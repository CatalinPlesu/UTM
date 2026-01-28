using AutoMapper;
using UtmShop.Model;

namespace UtmShop.Dto.Profiles
{
    public class ProductShortProfile : Profile
    {
        public ProductShortProfile()
        {
            CreateMap<Product, ProductShortDto>()
                .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.Title, opt => opt.MapFrom(src => src.Title))
                .ForMember(dest => dest.Price, opt => opt.MapFrom(src => src.Price))
                .ForMember(dest => dest.CategoryId, opt => opt.MapFrom(src => src.ParentCategory.Id));



        }
    }
}