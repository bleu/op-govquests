export interface Step {
  content: string;
  duration: number;
  status: string;
}

export interface Quest {
  img_url: string;
  title: string;
  reward_type: string;
  intro: string;
  steps: Step[];
}
