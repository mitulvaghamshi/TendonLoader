using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TendonLoaderApi.Data;
using TendonLoaderApi.Models;

namespace TendonLoaderApi.Controllers;

[Route("[controller]")]
[ApiController]
public class SettingsController : ControllerBase
{
    private readonly TendonLoaderContext _context;

    public SettingsController(TendonLoaderContext context) => _context = context;

    //// GET: api/Settings
    //[HttpGet]
    //public async Task<ActionResult<IEnumerable<Settings>>> GetSettings()
    //{
    //    if (_context.Settings == null) return NotFound();
    //    return await _context.Settings.AsNoTracking().ToListAsync();
    //}

    //// GET: api/Settings/5
    //[HttpGet("{id}")]
    //public async Task<ActionResult<Settings>> GetSettings(int id)
    //{
    //    if (_context.Settings == null) return NotFound();
    //    var settings = await _context.Settings.FindAsync(id);
    //    if (settings == null) return NotFound();
    //    return settings;
    //}

    // GET: api/Settings/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Settings>> GetSettings(int id)
    {
        if (_context.Settings == null) return NotFound();

        var settings = await _context.Settings.AsNoTracking()
            .FirstOrDefaultAsync(s => s.UserId == id);

        if (settings == null) return NotFound();

        return settings;
    }

    // PUT: api/Settings/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{id}")]
    public async Task<IActionResult> PutSettings(int id, Settings settings)
    {
        if (id != settings.Id) return BadRequest();

        _context.Entry(settings).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (SettingsExists(id)) throw;

            return NotFound();
        }

        return NoContent();
    }

    // POST: api/Settings
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost]
    public async Task<ActionResult<Settings>> PostSettings(Settings settings)
    {
        if (_context.Settings == null)
            return Problem("Entity set 'TendonLoaderContext.Settings' is null.");

        _context.Settings.Add(settings);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetSettings", new { id = settings.UserId }, settings);
    }

    // DELETE: api/Settings/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSettings(int id)
    {
        if (_context.Settings == null) return NotFound();

        var settings = await _context.Settings.FindAsync(id);
        if (settings == null) return NotFound();

        _context.Settings.Remove(settings);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool SettingsExists(int id) =>
        (_context.Settings?.AsNoTracking().Any(e => e.Id == id)).GetValueOrDefault();
}
