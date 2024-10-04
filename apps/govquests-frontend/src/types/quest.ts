export interface Action {
  content: string;
  duration: number;
}

export interface Reward {
  type: string;
  amount: number;
}

export interface Quest {
  id: string;
  image_url: string;
  title: string;
  rewards: Reward[];
  intro: string;
  actions: Action[];
  status: string;
}
