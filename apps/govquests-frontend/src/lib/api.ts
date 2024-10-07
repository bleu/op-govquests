async function api<T>(
  endpoint: string,
  { body, ...customConfig }: { body?: any; [key: string]: any } = {}
) {
  const headers = { "Content-Type": "application/json" };
  const config: RequestInit = {
    method: body ? "POST" : "GET",
    ...customConfig,
    headers: {
      ...headers,
      ...customConfig.headers,
    },
    cache: "no-store",
  };

  if (body) {
    config.body = JSON.stringify(body);
  }

  const apiUrl = "http://localhost:3001";
  const url = `${apiUrl}/${endpoint}`;

  try {
    const response = await fetch(url, config);

    if (!response.ok) {
      const errorMessage = await response.text();
      return Promise.reject(new Error(errorMessage));
    }

    const data = await response.json();
    return data as T;
  } catch (error) {
    return Promise.reject(error);
  }
}

export default api;
