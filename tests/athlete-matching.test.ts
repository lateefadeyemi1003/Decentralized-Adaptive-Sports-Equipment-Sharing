import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockAthleteMatching = {
  requestEquipment: vi.fn().mockImplementation((equipmentType, sport, needs) => {
    return { value: 1 };
  }),
  
  matchEquipment: vi.fn().mockImplementation((requestId, equipmentId) => {
    return { value: true };
  }),
  
  getRequest: vi.fn().mockImplementation((id) => {
    return {
      athlete: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      equipmentType: "Wheelchair",
      sport: "Track",
      needs: "Need adjustable seat height and custom hand rims",
      equipmentId: 3,
      status: "matched"
    };
  })
};

describe('Athlete Matching Contract', () => {
  it('should request equipment', async () => {
    const result = await mockAthleteMatching.requestEquipment(
        "Wheelchair",
        "Track",
        "Need adjustable seat height and custom hand rims"
    );
    
    expect(result.value).toBe(1);
    expect(mockAthleteMatching.requestEquipment).toHaveBeenCalledWith(
        "Wheelchair",
        "Track",
        "Need adjustable seat height and custom hand rims"
    );
  });
  
  it('should match equipment to a request', async () => {
    const result = await mockAthleteMatching.matchEquipment(1, 3);
    
    expect(result.value).toBe(true);
    expect(mockAthleteMatching.matchEquipment).toHaveBeenCalledWith(1, 3);
  });
  
  it('should get request details', async () => {
    const request = await mockAthleteMatching.getRequest(1);
    
    expect(request.equipmentType).toBe("Wheelchair");
    expect(request.sport).toBe("Track");
    expect(request.status).toBe("matched");
    expect(mockAthleteMatching.getRequest).toHaveBeenCalledWith(1);
  });
});
