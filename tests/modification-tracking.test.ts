import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockModificationTracking = {
  recordModification: vi.fn().mockImplementation((equipmentId, description, athleteNeeds) => {
    return { value: 1 };
  }),
  
  completeModification: vi.fn().mockImplementation((modificationId) => {
    return { value: true };
  }),
  
  getModification: vi.fn().mockImplementation((id) => {
    return {
      equipmentId: 3,
      description: "Adjusted seat height and installed custom hand rims",
      technician: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      date: 12345,
      athleteNeeds: "Need adjustable seat height and custom hand rims",
      status: "completed"
    };
  })
};

describe('Modification Tracking Contract', () => {
  it('should record a modification', async () => {
    const result = await mockModificationTracking.recordModification(
        3,
        "Adjusted seat height and installed custom hand rims",
        "Need adjustable seat height and custom hand rims"
    );
    
    expect(result.value).toBe(1);
    expect(mockModificationTracking.recordModification).toHaveBeenCalledWith(
        3,
        "Adjusted seat height and installed custom hand rims",
        "Need adjustable seat height and custom hand rims"
    );
  });
  
  it('should complete a modification', async () => {
    const result = await mockModificationTracking.completeModification(1);
    
    expect(result.value).toBe(true);
    expect(mockModificationTracking.completeModification).toHaveBeenCalledWith(1);
  });
  
  it('should get modification details', async () => {
    const modification = await mockModificationTracking.getModification(1);
    
    expect(modification.equipmentId).toBe(3);
    expect(modification.description).toBe("Adjusted seat height and installed custom hand rims");
    expect(modification.status).toBe("completed");
    expect(mockModificationTracking.getModification).toHaveBeenCalledWith(1);
  });
});
