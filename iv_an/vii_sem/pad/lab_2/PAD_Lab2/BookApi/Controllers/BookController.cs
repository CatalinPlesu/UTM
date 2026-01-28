using BookApi.Repositories;
using BookApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using Util.Models;

namespace BookApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookController : ControllerBase
    {
        private readonly IDbRepository<Book> _bookRepository;
        private readonly ISyncService<Book> _bookSyncService;

        public BookController(IDbRepository<Book> bookRepository, ISyncService<Book> bookSyncService)
        {
            _bookRepository = bookRepository;
            _bookSyncService = bookSyncService;
        }

        [HttpGet]
        public List<Book> GetAllBooks()
        {
            var records = _bookRepository.GetAllRecords();

            return records;
        }

        [HttpGet("{id}")]
        public Book GetBookById(Guid id)
        {
            var result = _bookRepository.GetRecordById(id);

            return result;
        }

        [HttpPost]
        public IActionResult Create(Book book)
        {
            book.LastChangedAt = DateTime.Now;
            var result = _bookRepository.InsertRecord(book);
            
            _bookSyncService.Upsert(book);

            return Ok(result);
        }

        [HttpPut]
        public IActionResult Upsert(Book book)
        {
            if(book.Id == Guid.Empty)
            {
                return BadRequest("Empty Id Field!");
            }

            book.LastChangedAt = DateTime.Now;
            _bookRepository.UpsertRecord(book);

            _bookSyncService.Upsert(book);

            return Ok(book);

        }

        [HttpDelete("{id}")]
        public IActionResult Delete(Guid id)
        {
            var book = _bookRepository.GetRecordById(id);

            if (book == null) 
            {
                return BadRequest("Movie does not exist!");
            }
            
            _bookRepository.DeleteRecord(id);

            book.LastChangedAt = DateTime.Now;
            _bookSyncService.Delete(book);

            return Ok("Deleted " + id);
        }

        [HttpPut("sync")]
        public IActionResult UpsertSync(Book book)
        {
            var existingBook = _bookRepository.GetRecordById(book.Id);

            if(existingBook == null || book.LastChangedAt > existingBook.LastChangedAt) 
            {
                _bookRepository.UpsertRecord(book);
            }

            return Ok(book);
        }

        [HttpDelete("sync")]
        public IActionResult DeleteSync(Book book)
        {
            var existingBook = _bookRepository.GetRecordById(book.Id);

            if (existingBook != null || book.LastChangedAt > existingBook.LastChangedAt)
            {
                _bookRepository.DeleteRecord(book.Id);
            }

            return Ok(book);
        }
    }
}
