import LoadingIndicator from "@/components/ui/LoadingIndicator";

export default function Loading() {
  return (
    <div className="flex flex-1 absolute inset-0 items-center justify-center h-full">
      <LoadingIndicator />
    </div>
  );
}
