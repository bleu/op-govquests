import type { Quest } from "../types/quest";

const API_BASE_URL = "http://localhost:3001";

export async function getQuests(): Promise<Quest[]> {
  try {
    const response = await fetch(`${API_BASE_URL}/quests`);
    if (!response.ok) {
      throw new Error("Network response was not ok");
    }
    const data: Quest[] = await response.json();
    return data;
  } catch (error) {
    console.error("There was a problem fetching the quests:", error);
    throw error;
  }
}

export async function getQuestById(id: string): Promise<Quest> {
  try {
    const response = await fetch(`${API_BASE_URL}/quests/${id}`);
    if (!response.ok) {
      throw new Error("Network response was not ok");
    }
    return await response.json();
  } catch (error) {
    console.error(
      `There was a problem fetching the quest with id ${id}:`,
      error,
    );
    throw error;
  }
}
