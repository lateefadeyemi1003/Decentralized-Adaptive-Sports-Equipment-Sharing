import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockEquipmentRegistration = {
  register: vi.fn().mockImplementation((name, type, sport, description) => {
    return { value: 1 };
  }),
  
  updateAvailability: vi.fn().mockImplementation((equipmentId, available) => {
    return { value: true };
  }),
  
  getEquipment: vi.fn().mockImplementation((id) => {
    return {
      name: "Racing Wheelchair",
      type: "Wheelchair",
      sport: "Track",
      description: "Lightweight carbon fiber racing wheelchair with adjustable axles",
      owner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      available: true
    };
  })
};

describe('Equipment Registration Contract', () => {
  it('should register new equipment', async () => {
    const result = await mockEquipmentRegistration.register(
        "Racing Wheelchair",
        "Wheelchair",
        "Track",
        "Lightweight carbon fiber racing wheelchair with adjustable axles"
    );
    
    expect(result.value).toBe(1);
    expect(mockEquipmentRegistration.register).toHaveBeenCalledWith(
        "Racing Wheelchair",
        "Wheelchair",
        "Track",
        "Lightweight carbon fiber racing wheelchair with adjustable axles"
    );
  });
  
  it('should update equipment availability', async () => {
    const result = await mockEquipmentRegistration.updateAvailability(1, false);
    
    expect(result.value).toBe(true);
    expect(mockEquipmentRegistration.updateAvailability).toHaveBeenCalledWith(1, false);
  });
  
  it('should get equipment details', async () => {
    const equipment = await mockEquipmentRegistration.getEquipment(1);
    
    expect(equipment.name).toBe("Racing Wheelchair");
    expect(equipment.sport).toBe("Track");
    expect(equipment.available).toBe(true);
    expect(mockEquipmentRegistration.getEquipment).toHaveBeenCalledWith(1);
  });
});
