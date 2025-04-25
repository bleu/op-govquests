export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="max-w-[1200px] mx-auto w-full md:px-6">{children}</div>
  );
}
