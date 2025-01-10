import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { TracksQuery } from "../graphql/tracksQuery";

export const fetchAllTracks = async () => {
  return await request(API_URL, TracksQuery);
};
