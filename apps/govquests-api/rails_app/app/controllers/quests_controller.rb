# app/controllers/quests_controller.rb
class QuestsController < ApplicationController
  def index
    quests = [
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        reward_type: "OP",
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
            status: "start"
          },
          {
            content: "Optimistic Vision",
            duration: 10,
            status: "start"
            
          },
          {
            content: "Working Constitution",
            duration: 15,
            status: "start"
          },
          {
            content: "Delegate Expectations",
            duration: 12,
            status: "start"
          },
        ]
      },
      {
        img_url: "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png",
        title: "Governance 101",
        reward_type: "POINTS",
        intro: "First things first: understand what are the Optimism Values and what is expect of you in this important role.",
        steps: [
          {
            content: "Code of Conduct",
            duration: 15,
            status: "start"
          },
          {
            content: "Optimistic Vision",
            duration: 15,
            status: "start"
            
          },
          {
            content: "Working Constitution",
            duration: 20,
            status: "start"
          },
          {
            content: "Delegate Expectations",
            duration: 25,
            status: "start"
          },
        ]
      },
    ]

    render json: quests
  end
end