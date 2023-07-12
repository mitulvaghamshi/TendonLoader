using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TendonLoaderApi.Data;
using TendonLoaderApi.Models;

namespace TendonLoaderApi.Controllers;

[Route("api/[controller]")]
[ApiController]
public class PrescriptionController : ControllerBase
{
    private readonly TendonLoaderContext _context;

    public PrescriptionController(TendonLoaderContext context) => _context = context;

    // GET: api/Prescription
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Prescription>>> GetPrescriptions()
    {
        if (_context.Prescriptions == null) return NotFound();

        return await _context.Prescriptions.AsNoTracking().ToListAsync();
    }

    // GET: api/Prescription/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Prescription>> GetPrescription(int id)
    {
        if (_context.Prescriptions == null) return NotFound();

        var prescription = await _context.Prescriptions.FindAsync(id);

        if (prescription == null) return NotFound();

        return prescription;
    }

    // GET: api/Prescription/Exercise/5
    [HttpGet("Exercise/{id}")]
    public async Task<ActionResult<Prescription>> GetExercisePrescription(int id)
    {
        if (_context.Prescriptions == null) return NotFound();

        var prescription = await _context.Prescriptions.FirstOrDefaultAsync(p => p.Exercise.Id == id);

        if (prescription == null) return NotFound();

        return prescription;
    }

    // GET: api/Prescription/Settings/5
    [HttpGet("Settings/{id}")]
    public async Task<ActionResult<Prescription>> GetSettingsPrescription(int id)
    {
        if (_context.Prescriptions == null) return NotFound();

        var prescription = await _context.Prescriptions.FirstOrDefaultAsync(p => p.Settings.Id == id);

        if (prescription == null) return NotFound();

        return prescription;
    }
    // PUT: api/Prescription/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{id}")]
    public async Task<IActionResult> PutPrescription(int id, Prescription prescription)
    {
        if (id != prescription.Id) return BadRequest();

        _context.Entry(prescription).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (PrescriptionExists(id)) throw;

            return NotFound();
        }

        return NoContent();
    }

    // POST: api/Prescription
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost]
    public async Task<ActionResult<Prescription>> PostPrescription(Prescription prescription)
    {
        if (_context.Prescriptions == null)
            return Problem("Entity set 'TendonLoaderContext.Prescriptions' is null.");

        _context.Prescriptions.Add(prescription);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetPrescription", new { id = prescription.Id }, prescription);
    }

    // DELETE: api/Prescription/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePrescription(int id)
    {
        if (_context.Prescriptions == null) return NotFound();

        var prescription = await _context.Prescriptions.FindAsync(id);
        if (prescription == null) return NotFound();

        _context.Prescriptions.Remove(prescription);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool PrescriptionExists(int id) =>
        (_context.Prescriptions?.AsNoTracking().Any(e => e.Id == id)).GetValueOrDefault();
}
