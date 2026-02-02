using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TendonLoaderApi.Data;
using TendonLoaderApi.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System;

namespace TendonLoaderApi.Controllers;

[Route("[controller]")]
[ApiController]
public class UserController : ControllerBase
{
    private readonly TendonLoaderContext _context;

    public UserController(TendonLoaderContext context) => _context = context;

    // GET: api/User
    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        if (_context.Users == null) return NotFound();

        return await _context.Users.AsNoTracking().ToListAsync();
    }

    // GET: api/User/sdfl+/sdfsdfs==
    [HttpGet("Auth/{credentials}")]
    public async Task<ActionResult<User>> GetUser(string credentials)
    {
        if (_context.Users == null || string.IsNullOrEmpty(credentials))
            return NotFound();

        string username, password;

        try
        {
            var bytes = Convert.FromBase64String(credentials);
            var values = Encoding.UTF8.GetString(bytes).Split(":");

            if (values.IsNullOrEmpty() || values.Length != 2)
                return NotFound();

            username = values[0].ReplaceLineEndings(string.Empty);
            password = values[1].ReplaceLineEndings(string.Empty);
        }
        catch (FormatException)
        {
            return NotFound();
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Username == username && u.Password == password);

        if (user == null) return NotFound();

        return user;
    }

    // GET: api/User/5
    [HttpGet("{id}")]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        if (_context.Users == null) return NotFound();

        var user = await _context.Users.FindAsync(id);

        if (user == null) return NotFound();

        return user;
    }

    // PUT: api/User/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{id}")]
    public async Task<IActionResult> PutUser(int id, User user)
    {
        if (id != user.Id) return BadRequest();

        _context.Entry(user).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (UserExists(id)) throw;

            return NotFound();
        }

        return NoContent();
    }

    // POST: api/User
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost]
    public async Task<ActionResult<User>> PostUser(User user)
    {
        if (_context.Users == null)
            return Problem("Entity set 'TendonLoaderContext.Users' is null.");

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetUser", new { id = user.Id }, user);
    }

    // DELETE: api/User/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        if (_context.Users == null) return NotFound();

        var user = await _context.Users.FindAsync(id);

        if (user == null) return NotFound();

        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool UserExists(int id) =>
        (_context.Users?.AsNoTracking().Any(e => e.Id == id)).GetValueOrDefault();
}
