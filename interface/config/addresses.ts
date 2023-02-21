// Used network
export const DefaultNetwork = "localhost";
export const CantoTestnetNetwork = "cantotest";

export const GetNoteAddress = (): `0x${string}` => {
  const network = process.env.NEXT_PUBLIC_NETWORK || DefaultNetwork;
  return addresses[network].note;
};

export const GetDaoFactoryAddress = (): `0x${string}` => {
  const network = process.env.NEXT_PUBLIC_NETWORK || DefaultNetwork;
  return addresses[network].daoFactory;
};

export const GetDaoListAddresses = (): `0x${string}`[] => {
  const network = process.env.NEXT_PUBLIC_NETWORK || DefaultNetwork;
  return addresses[network].daoList;
};

// Deployed addresses
const addresses: {
  [network: string]: {
    note: `0x${string}`;
    daoFactory: `0x${string}`;
    daoList: `0x${string}`[];
  };
} = {
  localhost: {
    note: "0xbf9fBFf01664500A33080Da5d437028b07DFcC55",
    daoFactory: "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
    daoList: [
      "0xa16E02E87b7454126E5E10d957A927A7F5B5d2be",
      "0xB7A5bd0345EF1Cc5E66bf61BdeC17D2461fBd968",
      "0xeEBe00Ac0756308ac4AaBfD76c05c4F3088B8883",
      "0x10C6E9530F1C1AF873a391030a1D9E8ed0630D26",
      "0x603E1BD79259EbcbAaeD0c83eeC09cA0B89a5bcC",
    ],
  },
  cantotest: {
    note: "0x79EF7FA6bfb942D7036E8397D1611710BC8AE774",
    daoFactory: "0x29D47977E4e9Afbdd564bb90576e5Df21dD77453",
    daoList: [
      "0x7E4F8B085fCf14a8e8f227Eb5c2700EB62ef0E38",
      "0xFFFa69928C6B62254c1811A2Cb35110711ef777d",
      "0x22887F9876F4D6Fb34813E336703bc771b082782",
    ],
  },
};
