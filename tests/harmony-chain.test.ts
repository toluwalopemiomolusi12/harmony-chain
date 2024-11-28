import { beforeEach, describe, it, expect } from 'vitest'

// Mock Clarity values and functions
const mockClarityValue = (type: string, value: any) => ({ type, value });

const ascii = (value: string) => mockClarityValue('ascii', value);
const uint = (value: number) => mockClarityValue('uint', value);
const principal = (value: string) => mockClarityValue('principal', value);
const bool = (value: boolean) => mockClarityValue('bool', value);

// Mock data variables
let compositions = new Map();
let collaborations = new Map();
let blockHeight = 2; 

// Mock contract calls
const contractCall = (method: string, args: any[], sender: string) => {
  switch (method) {
    case 'create-composition':
      const [title, hash, royalty] = args;
      const id = compositions.size;
      compositions.set(id, {
        owner: sender,
        title: title.value,
        'ipfs-hash': hash.value,
        'royalty-percentage': royalty.value,
        collaborators: []
      });
      return { ok: uint(id) };
    
    case 'invite-collaborator':
      const [compId, collaborator, share] = args;
      const collabKey = `${compId.value}-${collaborator.value}`;
      collaborations.set(collabKey, {
        accepted: false,
        'share-percentage': share.value
      });
      return { ok: bool(true) };
    
    case 'accept-collaboration':
      const [acceptCompId] = args;
      const acceptKey = `${acceptCompId.value}-${sender}`;
      const collab = collaborations.get(acceptKey);
      collab.accepted = true;
      return { ok: bool(true) };
    
    case 'get-composition':
      const [getCompId] = args;
      return { value: compositions.get(getCompId.value) };
    
    case 'get-collaboration':
      const [getCollabCompId, getCollaborator] = args;
      const getKey = `${getCollabCompId.value}-${getCollaborator.value}`;
      return { value: collaborations.get(getKey) };
  }
};

describe('Harmony Chain Contract', () => {
  const deployer = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
  const wallet1 = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
  
  beforeEach(() => {
    compositions.clear();
    collaborations.clear();
  });

  it('should create composition and handle collaboration flow', () => {
    // Create composition
    const createResult = contractCall(
      'create-composition',
      [ascii("My First Song"), ascii("QmHash123"), uint(10)],
      deployer
    );
    expect(createResult.ok.value).toBe(0);

    // Invite collaborator
    const inviteResult = contractCall(
      'invite-collaborator',
      [uint(0), principal(wallet1), uint(5)],
      deployer
    );
    expect(inviteResult.ok.value).toBe(true);

    // Accept collaboration
    const acceptResult = contractCall(
      'accept-collaboration',
      [uint(0)],
      wallet1
    );
    expect(acceptResult.ok.value).toBe(true);

    // Check composition details
    const compositionResult = contractCall(
      'get-composition',
      [uint(0)],
      deployer
    );
    expect(compositionResult.value.owner).toBe(deployer);
    expect(compositionResult.value.title).toBe("My First Song");
    expect(compositionResult.value['ipfs-hash']).toBe("QmHash123");
    expect(compositionResult.value['royalty-percentage']).toBe(10);

    // Check collaboration details
    const collaborationResult = contractCall(
      'get-collaboration',
      [uint(0), principal(wallet1)],
      deployer
    );
    expect(collaborationResult.value.accepted).toBe(true);
    expect(collaborationResult.value['share-percentage']).toBe(5);
  });
});