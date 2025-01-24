import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import RootLayout from '@/app/layout';

jest.mock('next/font/google', () => ({
  JetBrains_Mono: () => ({
    className: 'mocked-font',
    subsets: ['latin'],
  }),
}));

describe('RootLayout', () => {
  it('renders children within the layout', () => {
    const testContent = 'Test Content';
    render(<RootLayout>{testContent}</RootLayout>);
    
    expect(screen.getByText(testContent)).toBeInTheDocument();
    expect(document.documentElement).toHaveClass('dark');
    expect(document.documentElement).toHaveClass('bg-background');
  });
});
