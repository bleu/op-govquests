export interface Step {
  content: string;
  duration: number;
}

export interface Reward {
  type: string;
  amount: number;
}

export interface Quest {
  id: string;
  img_url: string;
  title: string;
  rewards: Reward[];
  intro: string;
  steps: Step[];
  status: string;
}
