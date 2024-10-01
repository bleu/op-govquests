# app/controllers/quests_controller.rb
class QuestsController < ApplicationController
  def index
    quests = [
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        status: "start",
        rewards: [
          {
            type: "Points",
            amount: 50
          },
          {
            type: "OP",
            amount: 2
          }
        ],
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
          },
          {
            content: "Optimistic Vision",
            duration: 10,
          },
          {
            content: "Working Constitution",
            duration: 15,
          },
          {
            content: "Delegate Expectations",
            duration: 12,
          },
        ]
      },
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        status: "start",
        rewards: [
          {
            type: "Points",
            amount: 100
          }
        ],
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
          },
          {
            content: "Optimistic Vision",
            duration: 15,
            
          },
          {
            content: "Working Constitution",
            duration: 20,
          },
          {
            content: "Delegate Expectations",
            duration: 25,
          },
        ]
      },
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        status: "start",
        rewards: [
          {
            type: "Points",
            amount: 50
          },
          {
            type: "OP",
            amount: 2
          }
        ],
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
          },
          {
            content: "Optimistic Vision",
            duration: 10,
            
          },
          {
            content: "Working Constitution",
            duration: 15,
          },
          {
            content: "Delegate Expectations",
            duration: 12,
          },
        ]
      },
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        status: "start",
        rewards: [
          {
            type: "Points",
            amount: 100
          }
        ],
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
          },
          {
            content: "Optimistic Vision",
            duration: 15,
            
          },
          {
            content: "Working Constitution",
            duration: 20,
          },
          {
            content: "Delegate Expectations",
            duration: 25,
          },
        ]
      },
    ]

    render json: quests
  end
  def show
    quest = {
      img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
      title: "Governance 101",
      status: "start",
      rewards: [
        {
          type: "Points",
          amount: 50
        },
        {
          type: "OP",
          amount: 2
        }
      ],
      intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
      steps: [
        {
          content: "Code of Conduct",
          duration: 15,
        },
        {
          content: "Optimistic Vision",
          duration: 10,
        },
        {
          content: "Working Constitution",
          duration: 15,
        },
        {
          content: "Delegate Expectations",
          duration: 12,
        },
      ]
    }

    render json: quest
  end
end