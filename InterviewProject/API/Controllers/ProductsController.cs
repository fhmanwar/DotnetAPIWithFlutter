using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using API.Context;
using API.Models;
using API.Repository;
using API.ViewModels;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategorysController : ControllerBase
    {
        private readonly MyContext _context;
        public IConfiguration _configuration;
        ProductCategoryRepo _repo;

        public CategorysController(MyContext myContext, IConfiguration config, ProductCategoryRepo repo)
        {
            _context = myContext;
            _configuration = config;
            _repo = repo;
        }

        [HttpGet]
        public async Task<IEnumerable<CategoryProductVM>> GetAll() => await _repo.getAll();

        [HttpGet("{id}")]
        public CategoryProductVM GetID(int id) => _repo.getID(id);

        [HttpPost]
        public IActionResult Create(CategoryProductVM dataVM)
        {
            if (ModelState.IsValid)
            {
                var category = new ProductCategory
                {
                    CategoryName = dataVM.Name
                };
                _context.Categories.Add(category);
                _context.SaveChanges();
                return Ok("Successfully Created");
            }
            return BadRequest("Not Successfully");
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, CategoryProductVM dataVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Categories.SingleOrDefault(x => x.CategoryId == id);
                getData.CategoryName = dataVM.Name;

                _context.Categories.Update(getData);
                _context.SaveChanges();

                return Ok("Successfully Updated");
            }
            return BadRequest("Not Successfully");
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var getData = _context.Categories.SingleOrDefault(x => x.CategoryId == id);
            if (getData == null)
            {
                return BadRequest("Not Successfully");
            }

            //_context.Entry(getData).State = EntityState.Modified;
            _context.Categories.Remove(getData);
            _context.SaveChanges();
            return Ok(new { msg = "Successfully Delete" });
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly MyContext _context;
        public IConfiguration _configuration;
        ProductRepo _repo;

        public ProductsController(MyContext myContext, IConfiguration config, ProductRepo repo)
        {
            _context = myContext;
            _configuration = config;
            _repo = repo;
        }

        [HttpGet]
        public async Task<IEnumerable<ProductVM>> GetAll() => await _repo.getAll();

        [HttpGet("{id}")]
        public ProductVM GetID(int id) => _repo.getID(id);

        [HttpPost]
        public IActionResult Create(ProductVM getDataVM)
        {
            var getUser = _context.Products.Where(x => x.ProductName == getDataVM.ProductName);
            if (getUser.Count() == 0)
            {
                if (ModelState.IsValid)
                {
                    var getCatId = _context.Categories.SingleOrDefault(x => x.CategoryName == getDataVM.CategoryName);
                    var data = new Product
                    {
                        ProductName = getDataVM.ProductName,
                        Stock = getDataVM.Stock,
                        Price = getDataVM.Price,
                        Unit = getDataVM.Unit,
                        CategoryId = getCatId.CategoryId,
                    };
                    _context.Products.Add(data);
                    _context.SaveChanges();

                    return Ok("Successfully Created");
                }
                return BadRequest("Not Successfully");
            }
            return BadRequest("Name Already Exists ");
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, ProductVM dataVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Products.Include("ProductCategory").SingleOrDefault(x => x.ProductId == id);
                getData.ProductName = dataVM.ProductName;
                getData.Stock = dataVM.Stock;
                getData.Price = dataVM.Price;
                getData.Unit = dataVM.Unit;
                if (dataVM.CategoryName != null)
                {
                    var getCatId = _context.Categories.SingleOrDefault(x => x.CategoryName == dataVM.CategoryName);
                    getData.CategoryId = getCatId.CategoryId;
                }
                _context.Products.Update(getData);
                _context.SaveChanges();

                return Ok("Successfully Updated");
            }
            return BadRequest("Not Successfully");
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var getData = _context.Products.SingleOrDefault(x => x.ProductId == id);
            if (getData == null)
            {
                return BadRequest("Not Successfully");
            }

            _context.Products.Remove(getData);
            _context.SaveChanges();

            return Ok(new { msg = "Successfully Delete" });
        }
    }
}
