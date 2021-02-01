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
using Microsoft.Extensions.Configuration;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartsController : ControllerBase
    {
        private readonly MyContext _context;
        public IConfiguration _configuration;
        CartRepo _repo;

        public CartsController(MyContext myContext, IConfiguration config, CartRepo repo)
        {
            _context = myContext;
            _configuration = config;
            _repo = repo;
        }

        [HttpGet]
        public async Task<IEnumerable<CartVM>> GetAll() => await _repo.getAll();

        [HttpGet("{id}")]
        public CartVM GetID(int id) => _repo.getID(id);

        [HttpPost]
        public IActionResult Create(getCartVM dataVM)
        {
            if (ModelState.IsValid)
            {
                var getId = _context.Products.SingleOrDefault(x => x.ProductName == dataVM.ProductName);
                var getSubTotal = getId.Price * dataVM.Quantity;
                var data = new Cart
                {
                    UserId = dataVM.UserId,
                    ProductId = getId.ProductId,
                    Quantity = dataVM.Quantity,
                    SubTotal = getSubTotal,
                };
                _context.Carts.Add(data);
                _context.SaveChanges();

                return Ok(new { msg = "Successfully Created", status = true });
            }
            return BadRequest(new { msg = "Not Successfully", status = false });
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, CartVM dataVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Carts.SingleOrDefault(x => x.Id == id);
                getData.Quantity = dataVM.Quantity;
                getData.SubTotal = dataVM.SubTotal;
                _context.Carts.Update(getData);
                _context.SaveChanges();

                return Ok(new { msg = "Successfully Updated", status = true });
            }
            return BadRequest(new { msg = "Not Successfully", status = false });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var getData = _context.Carts.SingleOrDefault(x => x.Id == id);
            if (getData == null)
            {
                return BadRequest(new { msg = "Not Successfully", status = false });
            }

            _context.Carts.Remove(getData);
            _context.SaveChanges();

            return Ok(new { msg = "Successfully Delete" });
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class TransactionsController : ControllerBase
    {
        private readonly MyContext _context;
        public IConfiguration _configuration;
        TransactionRepo _repo;

        public TransactionsController(MyContext myContext, IConfiguration config, TransactionRepo repo)
        {
            _context = myContext;
            _configuration = config;
            _repo = repo;
        }

        [HttpGet]
        public async Task<IEnumerable<TransactionVM>> GetAll() => await _repo.getAll();

        [HttpGet("{id}")]
        public TransactionVM GetID(int id) => _repo.getID(id);

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] TransactionVM dataVM)
        {
            var dataT = new TransactionVM
            {
                UserId = dataVM.UserId,
                Total = dataVM.Total,
            };
            var create = _repo.Create(dataT);
            if (create > 0)
            {
                var getTransactionId = _context.Transactions.Max(x => x.TransactionId);
                foreach (TransactionItemVM ti in dataVM.transactionItems)
                {
                    var getProductId = _context.Products.SingleOrDefault(x => x.ProductName == ti.ProductName);
                    var data = new TransactionItem
                    {
                        TransactionId = getTransactionId,
                        ProductId = getProductId.ProductId,
                        Quantity = ti.Quantity,
                        SubTotal = ti.SubTotal,
                    };
                    await _context.TransactionItems.AddAsync(data);

                    var getCart = _context.Carts.SingleOrDefault(x => x.ProductId == getProductId.ProductId && x.UserId == dataVM.UserId);
                    _context.Carts.Remove(getCart);

                }
                await _context.SaveChangesAsync();

                return Ok("Successfully Created");
            }
            return BadRequest("Input User Not Successfully");
        }
    }
}
