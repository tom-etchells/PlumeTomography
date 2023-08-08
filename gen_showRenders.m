%% Setup
% clear variables
close all
% clc

%% Read renders

figRender = figure();
figure(figRender)

% Tomog processing
x = double(images(1).alpha);
rayBurdens = 0.08308 * exp(0.01492 * x);
rayBurdens = rayBurdens / 10;
rayBurdens(rayBurdens > 0.05) = 0.05;
rayBurdens(rayBurdens < 0.015) = 0.015;

% % sat Tomog processing
% x = double(images(1).alpha);
% rayBurdens = 3.195e+08 * exp(0.01515  * x);

image(rayBurdens, 'CDataMapping','scaled');

xlabel('x Pixel')
ylabel('y Pixel')
% title('Line-of-Sight Mass Burdens')

axis square
xlim([270 370])
ylim([206 306])

set(gca, 'FontSize', 14, 'FontWeight', 'bold')
colorbar('southoutside');


% export at 600 dpi
% exportgraphics(figRender, 'renderCB.png', 'Resolution', 600)